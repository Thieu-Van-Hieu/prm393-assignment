// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'application_response.dart';

class ApplicationResponseMapper extends ClassMapperBase<ApplicationResponse> {
  ApplicationResponseMapper._();

  static ApplicationResponseMapper? _instance;
  static ApplicationResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ApplicationResponseMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ApplicationResponse';

  static String _$id(ApplicationResponse v) => v.id;
  static const Field<ApplicationResponse, String> _f$id = Field('id', _$id);
  static String _$title(ApplicationResponse v) => v.title;
  static const Field<ApplicationResponse, String> _f$title = Field(
    'title',
    _$title,
  );
  static String _$status(ApplicationResponse v) => v.status;
  static const Field<ApplicationResponse, String> _f$status = Field(
    'status',
    _$status,
  );
  static String _$sentDate(ApplicationResponse v) => v.sentDate;
  static const Field<ApplicationResponse, String> _f$sentDate = Field(
    'sentDate',
    _$sentDate,
  );
  static String? _$processedDate(ApplicationResponse v) => v.processedDate;
  static const Field<ApplicationResponse, String> _f$processedDate = Field(
    'processedDate',
    _$processedDate,
    opt: true,
  );
  static String? _$handlerName(ApplicationResponse v) => v.handlerName;
  static const Field<ApplicationResponse, String> _f$handlerName = Field(
    'handlerName',
    _$handlerName,
    opt: true,
  );
  static String? _$fromDate(ApplicationResponse v) => v.fromDate;
  static const Field<ApplicationResponse, String> _f$fromDate = Field(
    'fromDate',
    _$fromDate,
    opt: true,
  );
  static String? _$toDate(ApplicationResponse v) => v.toDate;
  static const Field<ApplicationResponse, String> _f$toDate = Field(
    'toDate',
    _$toDate,
    opt: true,
  );
  static String _$requestContent(ApplicationResponse v) => v.requestContent;
  static const Field<ApplicationResponse, String> _f$requestContent = Field(
    'requestContent',
    _$requestContent,
  );
  static String? _$responseContent(ApplicationResponse v) => v.responseContent;
  static const Field<ApplicationResponse, String> _f$responseContent = Field(
    'responseContent',
    _$responseContent,
    opt: true,
  );

  @override
  final MappableFields<ApplicationResponse> fields = const {
    #id: _f$id,
    #title: _f$title,
    #status: _f$status,
    #sentDate: _f$sentDate,
    #processedDate: _f$processedDate,
    #handlerName: _f$handlerName,
    #fromDate: _f$fromDate,
    #toDate: _f$toDate,
    #requestContent: _f$requestContent,
    #responseContent: _f$responseContent,
  };

  static ApplicationResponse _instantiate(DecodingData data) {
    return ApplicationResponse(
      id: data.dec(_f$id),
      title: data.dec(_f$title),
      status: data.dec(_f$status),
      sentDate: data.dec(_f$sentDate),
      processedDate: data.dec(_f$processedDate),
      handlerName: data.dec(_f$handlerName),
      fromDate: data.dec(_f$fromDate),
      toDate: data.dec(_f$toDate),
      requestContent: data.dec(_f$requestContent),
      responseContent: data.dec(_f$responseContent),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ApplicationResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ApplicationResponse>(map);
  }

  static ApplicationResponse fromJson(String json) {
    return ensureInitialized().decodeJson<ApplicationResponse>(json);
  }
}

mixin ApplicationResponseMappable {}

