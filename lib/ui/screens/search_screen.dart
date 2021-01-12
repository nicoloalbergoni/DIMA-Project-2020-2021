import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/redux/actions.dart';
import 'package:realiteye/redux/app_state.dart';
import 'package:realiteye/ui/widgets/custom_appbar.dart';
import 'package:realiteye/ui/widgets/filter_bar.dart';
import 'package:realiteye/ui/widgets/search_box.dart';
import 'package:realiteye/ui/widgets/search_listview_builder.dart';
import 'package:realiteye/ui/widgets/side_menu.dart';
import 'package:realiteye/utils/search_filters.dart';
import 'package:realiteye/utils/search_filters_callbacks.dart';
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
  SearchFilters _searchState;
  SearchFiltersCallbacks _searchFiltersCallbacks;
  SearchScreenViewModel vm;

  @override
  void initState() {
    super.initState();
    showHistory = false;
    showSearchResult = false;
    _searchFocus.addListener(_onFocusChange);
    _searchState = SearchFilters();
    _searchFiltersCallbacks = SearchFiltersCallbacks(
        _onDropdownChanged,
        _onFilterButtonPressed,
        _onARToggleChanged,
        _onPriceSliderChanged,
        _onCategoriesSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    _searchState.dropdownValue,
                    _searchState.showFilters,
                    _searchState.showAROnly,
                    _searchState.priceRangeValues,
                    _searchState.categoriesBool,
                    _searchFiltersCallbacks,
                  ),
                  (showHistory || viewModel.searchHistory.length == 0)
                      ? Flexible(child: _buildHistoryList())
                      : Container(),
                  showSearchResult
                      ? Expanded(child: SearchListViewBuilder(_searchState))
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

  //TODO: Handle display of search results when unfocus
  void _onFocusChange() {
    setState(() {
      if (_searchFocus.hasFocus) {
        showHistory = true;
        showSearchResult = false;
      } else {
        //showSearchResult = true;
        showHistory = false;
      }
    });
  }

  void _searchPressed() {
    List<String> history = vm.searchHistory;

    setState(() {
      _searchState.queryText = _searchController.text;
      if (_searchController.text.isNotEmpty &&
          !history.contains(_searchController.text))
        vm.addHistoryItemCallback(_searchController.text);

      _searchFocus.unfocus();
      //_searchController.clear();
      showHistory = false;
      showSearchResult = _searchController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onDropdownChanged(String newValue) {
    setState(() {
      _searchState.dropdownValue = newValue;
    });
  }

  void _onFilterButtonPressed() {
    setState(() {
      _searchState.showFilters = !_searchState.showFilters;
    });
  }

  void _onARToggleChanged(bool value) {
    setState(() {
      _searchState.showAROnly = value;
    });
  }

  void _onPriceSliderChanged(RangeValues values) {
    setState(() {
      _searchState.priceRangeValues = values;
    });
  }

  void _onCategoriesSelected(String category, BuildContext context) {
    bool isCategorySelected = _searchState.categoriesBool[category];
    int categoryCount = 0;
    if (!isCategorySelected) {
      _searchState.categoriesBool.forEach((_, value) {
        if (value) categoryCount++;
      });
    }

    if (categoryCount < 10) {
      setState(() {
        _searchState.categoriesBool[category] = !_searchState.categoriesBool[category];
      });
    }
    else displaySnackbarWithText(context, "You can select up to 10 categories");
  }
}
