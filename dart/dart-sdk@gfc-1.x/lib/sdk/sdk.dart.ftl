<#if license??>
${dart.license(license)}
</#if>
export 'memory.dart';
export 'options.dart';

enum DataState { idle, loading, success, error }