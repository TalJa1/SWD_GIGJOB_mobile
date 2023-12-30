class MetaDataDTO{
  int page;
  int size;
  int total;

  MetaDataDTO({required this.page,required this.size,required this.total});

  factory MetaDataDTO.fromJson(dynamic json){
    return MetaDataDTO(
      page: json['page'],
      size: json['size'],
      total: json['total']
    );
  }
}