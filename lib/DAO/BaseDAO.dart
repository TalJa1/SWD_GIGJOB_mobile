

import 'package:gigjob_mobile/DTO/MetaDataDTO.dart';

class BaseDAO{
  late MetaDataDTO _metaDataDTO;

  MetaDataDTO get metaDataDTO => _metaDataDTO;

  set metaDataDTO(MetaDataDTO value) {
    _metaDataDTO = value;
  }
}