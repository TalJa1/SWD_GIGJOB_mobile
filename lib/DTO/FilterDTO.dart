class FilterDTO {
  List<SearchCriteriaList>? searchCriteriaList;
  String? dataOption;

  FilterDTO({this.searchCriteriaList, this.dataOption});

  FilterDTO.fromJson(Map<String, dynamic> json) {
    if (json['searchCriteriaList'] != null) {
      searchCriteriaList = <SearchCriteriaList>[];
      json['searchCriteriaList'].forEach((v) {
        searchCriteriaList!.add(new SearchCriteriaList.fromJson(v));
      });
    }
    dataOption = json['dataOption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.searchCriteriaList != null) {
      data['searchCriteriaList'] =
          this.searchCriteriaList!.map((v) => v.toJson()).toList();
    }
    data['dataOption'] = this.dataOption;
    return data;
  }
}

class SearchCriteriaList {
  String? filterKey;
  String? value;
  String? operation;
  String? dataOption;
  SortCriteria? sortCriteria;

  SearchCriteriaList(
      {this.filterKey,
      this.value,
      this.operation,
      this.dataOption,
      this.sortCriteria});

  SearchCriteriaList.fromJson(Map<String, dynamic> json) {
    filterKey = json['filterKey'];
    value = json['value'];
    operation = json['operation'];
    dataOption = json['dataOption'];
    sortCriteria = json['sortCriteria'] != null
        ? new SortCriteria.fromJson(json['sortCriteria'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filterKey'] = this.filterKey;
    data['value'] = this.value;
    data['operation'] = this.operation;
    data['dataOption'] = this.dataOption;
    if (this.sortCriteria != null) {
      data['sortCriteria'] = this.sortCriteria!.toJson();
    }
    return data;
  }
}

class SortCriteria {
  String? sortKey;
  String? direction;

  SortCriteria({this.sortKey, this.direction});

  SortCriteria.fromJson(Map<String, dynamic> json) {
    sortKey = json['sortKey'];
    direction = json['direction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sortKey'] = this.sortKey;
    data['direction'] = this.direction;
    return data;
  }
}