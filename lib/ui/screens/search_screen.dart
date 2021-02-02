import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/models/search_filters.dart';
import 'package:realiteye/models/search_filters_callbacks.dart';
import 'package:realiteye/redux/actions.dart';
import 'package:realiteye/redux/app_state.dart';
import 'package:realiteye/ui/widgets/custom_appbar.dart';
import 'package:realiteye/ui/widgets/filter_bar.dart';
import 'package:realiteye/ui/widgets/search_box.dart';
import 'package:realiteye/ui/widgets/search_listview_builder.dart';
import 'package:realiteye/ui/widgets/side_menu.dart';
import 'package:realiteye/utils/data_service.dart';
import 'package:realiteye/utils/utils.dart';
import 'package:realiteye/view_models/search_screen_vm.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  bool showHistory;
  bool showSearchResult;
  SearchFilters _searchFilters;
  SearchFiltersCallbacks _searchFiltersCallbacks;
  SearchScreenViewModel vm;
  List<DocumentSnapshot> retrievedDocs = new List<DocumentSnapshot>();

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    showHistory = false;
    showSearchResult = false;
    _searchFocus.addListener(_onFocusChange);
    _searchFilters = SearchFilters();
    _searchFiltersCallbacks = SearchFiltersCallbacks(
        _onDropdownChanged,
        _onFilterButtonPressed,
        _onARToggleChanged,
        _onPriceSliderChanged,
        _onCategoriesSelected
    );
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final SearchFilters args = ModalRoute.of(context).settings.arguments;
    if (args != null) {
      _searchFilters = args;
      _searchController.text = args.queryText;

      // launch search after screen is built
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _searchPressed());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(LocaleKeys.search_title.tr()),
      drawer: SideMenu(),
      body: StoreConnector<AppState, SearchScreenViewModel>(
          converter: (store) {
            return SearchScreenViewModel(
                searchHistory: store.state.searchHistory,
                addHistoryItemCallback: (item) =>
                    store.dispatch(AddHistoryItemAction(item)),
            );
          },
          builder: (context, viewModel) {
            vm = viewModel;

            return Padding(
              padding: EdgeInsets.all(7),
              child: Column(
                children: [
                  SearchBox(
                    _searchController,
                    _searchFocus,
                    _searchPressed,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  FilterBar(
                    _searchFilters.orderingKey,
                    _searchFilters.showFilters,
                    _searchFilters.showAROnly,
                    _searchFilters.priceRangeValues,
                    _searchFilters.categoriesBool,
                    _searchFiltersCallbacks,
                  ),
                  (showHistory || viewModel.searchHistory.length == 0)
                      ? Flexible(child: _buildHistoryList())
                      : Container(),
                  (showSearchResult && retrievedDocs.length > 0)
                      ? Expanded(child: SearchListViewBuilder(retrievedDocs,
                          _getFilteredProductDocs, _onSearchDataRefresh))
                      : Container(),
                ],
              ),
            );
          },
      )
    );
  }

  Widget _buildHistoryList() {
    List<String> history = vm.searchHistory;
    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(history[index]),
          onTap: () {
            _searchController.text = history[index];
            _searchPressed();
          },
          leading: Icon(Icons.history),
        );
      },
    );
  }

  void _onFocusChange() {
    setState(() {
      if (_searchFocus.hasFocus) {
        showHistory = true;
        showSearchResult = false;
      } else {
        showSearchResult = true;
        showHistory = false;
      }
    });
  }

  void _searchPressed() async {
    List<String> history = vm.searchHistory;
    String searchText = _searchController.text;

    setState(() {
      retrievedDocs = [];
    });
    print('Previous product docs data deleted');

    _searchFilters.queryText = searchText;
    if (searchText.isNotEmpty && !history.contains(searchText)) {
      vm.addHistoryItemCallback(searchText);
    }
    _searchFocus.unfocus();

    await _getFilteredProductDocs();

    setState(() {
      showHistory = false;
      showSearchResult = true;
    });
  }

  Future<void> _getFilteredProductDocs() async {
    DocumentSnapshot lastVisible = (retrievedDocs.length > 0)
        ? retrievedDocs.last : null;
    List<DocumentSnapshot> data = await getSearchQueryResult(_searchFilters, lastVisible);

    if (data != null && data.length > 0) {
      setState(() {
        retrievedDocs.addAll(data);
      });
      print('New product docs added');
    }
    else {
      // TODO: workaround to avoid context propagation
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(LocaleKeys.snackbar_no_more_items.tr())));
    }
  }

  void _onSearchDataRefresh() async {
    // TODO: this cause the blank section flash during refresh, how to improve it?
    setState(() {
      retrievedDocs = [];
    });
    print('Previous product docs data deleted');
    await _getFilteredProductDocs();
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onDropdownChanged(String newValue) {
    setState(() {
      _searchFilters.orderingKey = newValue;
    });
  }

  void _onFilterButtonPressed() {
    setState(() {
      _searchFilters.showFilters = !_searchFilters.showFilters;
    });
  }

  void _onARToggleChanged(bool value) {
    setState(() {
      _searchFilters.showAROnly = value;
    });
  }

  void _onPriceSliderChanged(RangeValues values) {
    setState(() {
      _searchFilters.priceRangeValues = values;
    });
  }

  void _onCategoriesSelected(String category, BuildContext context) {
    bool isCategorySelected = _searchFilters.categoriesBool[category];
    int categoryCount = 0;
    if (!isCategorySelected) {
      _searchFilters.categoriesBool.forEach((_, value) {
        if (value) categoryCount++;
      });
    }

    if (categoryCount < 10) {
      setState(() {
        _searchFilters.categoriesBool[category] = !_searchFilters.categoriesBool[category];
      });
    }
    else displaySnackbarWithText(context, LocaleKeys.snackbar_categories_limit.tr());
  }
}
