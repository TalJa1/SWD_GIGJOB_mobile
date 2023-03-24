class FilterDTO {
  List<SearchCriteriaList>? searchCriteriaList;
  SortCriteria? sortCriteria;
  String? dataOption;
  double? latitude;
  double? longitude;

  FilterDTO(
      {this.searchCriteriaList,
      this.sortCriteria,
      this.dataOption,
      this.latitude,
      this.longitude});

  FilterDTO.fromJson(Map<String, dynamic> json) {
    if (json['searchCriteriaList'] != null) {
      searchCriteriaList = <SearchCriteriaList>[];
      json['searchCriteriaList'].forEach((v) {
        searchCriteriaList!.add(new SearchCriteriaList.fromJson(v));
      });
    }
    sortCriteria = json['sortCriteria'] != null
        ? new SortCriteria.fromJson(json['sortCriteria'])
        : null;
    dataOption = json['dataOption'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.searchCriteriaList != null) {
      data['searchCriteriaList'] =
          this.searchCriteriaList!.map((v) => v.toJson()).toList();
    }
    if (this.sortCriteria != null) {
      data['sortCriteria'] = this.sortCriteria!.toJson();
    }
    data['dataOption'] = this.dataOption;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class SearchCriteriaList {
  String? filterKey;
  String? value;
  String? operation;

  SearchCriteriaList({this.filterKey, this.value, this.operation});

  SearchCriteriaList.fromJson(Map<String, dynamic> json) {
    filterKey = json['filterKey'];
    value = json['value'];
    operation = json['operation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filterKey'] = this.filterKey;
    data['value'] = this.value;
    data['operation'] = this.operation;
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
