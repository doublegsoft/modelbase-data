<#import "/$/modelbase.ftl" as modelbase>
<#if license??>
${c.license(license)}
</#if>

#define _XOPEN_SOURCE 700
#define _DEFAULT_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include <errno.h>
#include <time.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <unistd.h>
#include <sys/time.h>

void* 
${namespace}_mem_alloc(size_t size)
{
  return malloc(size);
}

void* 
${namespace}_mem_calloc(size_t count, size_t size)
{
  return calloc(count, size);
}

void* 
${namespace}_mem_realloc(void* ptr, size_t size)
{
  return realloc(ptr, size);
}

void 
${namespace}_mem_free(void* ptr)
{
  free(ptr);
}

void 
${namespace}_mem_set(void* dst, int value, size_t size)
{
  memset(dst, value, size);
}

void 
${namespace}_mem_copy(void* dst, const void* src, size_t size)
{
  memcpy(dst, src, size);
}

void 
${namespace}_mem_move(void* dst, const void* src, size_t size)
{
  memmove(dst, src, size);
}

int 
${namespace}_mem_compare(const void* a, const void* b, size_t size)
{
  return memcmp(a, b, size);
}

size_t 
${namespace}_str_length(const char* str)
{
  if (str == NULL) {
    return 0;
  }

  return strlen(str);
}

int 
${namespace}_str_compare(const char* a, const char* b)
{
  if (a == NULL && b == NULL) {
    return 0;
  }

  if (a == NULL) {
    return -1;
  }

  if (b == NULL) {
    return 1;
  }

  return strcmp(a, b);
}

int 
${namespace}_str_equal(const char* a, const char* b)
{
  return ${namespace}_str_compare(a, b) == 0;
}

char* 
${namespace}_str_copy(char* dst, const char* src)
{
  if (dst == NULL || src == NULL) {
    return NULL;
  }

  return strcpy(dst, src);
}

char* 
${namespace}_str_duplicate(const char* str)
{
  size_t size;
  char* result;

  if (str == NULL) {
    return NULL;
  }

  size = strlen(str) + 1;
  result = (char*)${namespace}_mem_alloc(size);

  if (result == NULL) {
    return NULL;
  }

  ${namespace}_mem_copy(result, str, size);

  return result;
}

const char* 
${namespace}_str_find(const char* str, int value)
{
  if (str == NULL) {
    return NULL;
  }

  return strchr(str, value);
}

int 
${namespace}_str_prefix(const char* str, const char* prefix)
{
  size_t length;

  if (str == NULL || prefix == NULL) {
    return 0;
  }

  length = strlen(prefix);

  return strncmp(str, prefix, length) == 0;
}

int 
${namespace}_str_suffix(const char* str, const char* suffix)
{
  size_t str_size;
  size_t suffix_size;

  if (str == NULL || suffix == NULL) {
    return 0;
  }

  str_size = strlen(str);
  suffix_size = strlen(suffix);

  if (suffix_size > str_size) {
    return 0;
  }

  return strcmp(str + str_size - suffix_size, suffix) == 0;
}

int64_t 
${namespace}_time_millis(void)
{
  struct timeval tv;

  gettimeofday(&tv, NULL);

  return (int64_t)tv.tv_sec * 1000 + tv.tv_usec / 1000;
}

int 
${namespace}_net_set_timeout(int fd, int timeout_ms)
{
  struct timeval tv;

  tv.tv_sec = timeout_ms / 1000;
  tv.tv_usec = (timeout_ms % 1000) * 1000;

  if (setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv)) != 0) {
    return -1;
  }

  if (setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &tv, sizeof(tv)) != 0) {
    return -1;
  }

  return 0;
}

int 
${namespace}_net_connect(const char* host, uint16_t port, int timeout_ms)
{
  char port_string[16];
  struct addrinfo hints;
  struct addrinfo* result;
  struct addrinfo* current;
  int fd = -1;
  int rc;

  if (host == NULL) {
    return -1;
  }

  snprintf(port_string, sizeof(port_string), "%u", port);

  ${namespace}_mem_set(&hints, 0, sizeof(hints));
  hints.ai_family = AF_UNSPEC;
  hints.ai_socktype = SOCK_STREAM;

  rc = getaddrinfo(host, port_string, &hints, &result);
  if (rc != 0) {
    return -1;
  }

  for (current = result; current != NULL; current = current->ai_next) {
    fd = socket(current->ai_family, current->ai_socktype, current->ai_protocol);
    if (fd < 0) {
      continue;
    }

    if (${namespace}_net_set_timeout(fd, timeout_ms) != 0) {
      close(fd);
      fd = -1;
      continue;
    }

    if (connect(fd, current->ai_addr, current->ai_addrlen) == 0) {
      break;
    }

    close(fd);
    fd = -1;
  }

  freeaddrinfo(result);

  return fd;
}

ssize_t 
${namespace}_net_read(int fd, void* data, size_t size)
{
  return recv(fd, data, size, 0);
}

ssize_t 
${namespace}_net_write(int fd, const void* data, size_t size)
{
  return send(fd, data, size, 0);
}

int 
${namespace}_net_write_all(int fd, const void* data, size_t size)
{
  const unsigned char* ptr;
  size_t written;
  ssize_t n;

  ptr = (const unsigned char*)data;
  written = 0;

  while (written < size) {
    n = ${namespace}_net_write(fd, ptr + written, size - written);

    if (n < 0) {
      if (errno == EINTR) {
        continue;
      }
      return -1;
    }

    if (n == 0) {
      return -1;
    }

    written += (size_t)n;
  }

  return 0;
}

int 
${namespace}_net_close(int fd)
{
  return close(fd);
}

int 
${namespace}_date_now_utc(struct tm* tm_out)
{
  time_t now;

  if (tm_out == NULL) {
    return -1;
  }

  now = time(NULL);
  if (gmtime_r(&now, tm_out) == NULL) {
    return -1;
  }

  return 0;
}

int 
${namespace}_date_now_local(struct tm* tm_out)
{
  time_t now;

  if (tm_out == NULL) {
    return -1;
  }

  now = time(NULL);
  if (localtime_r(&now, tm_out) == NULL) {
    return -1;
  }

  return 0;
}

int64_t 
${namespace}_date_to_timestamp_utc(const struct tm* tm_in)
{
  struct tm tmp;

  if (tm_in == NULL) {
    return -1;
  }

  tmp = *tm_in;

#if defined(_GNU_SOURCE) || defined(_BSD_SOURCE)
  return (int64_t)timegm(&tmp);
#else
  return (int64_t)mktime(&tmp) - timezone;
#endif
}

int64_t 
${namespace}_date_to_timestamp_local(struct tm* tm_in)
{
  time_t ts;

  if (tm_in == NULL) {
    return -1;
  }

  ts = mktime(tm_in);
  if (ts == (time_t)-1) {
    return -1;
  }

  return (int64_t)ts;
}

int 
${namespace}_date_from_timestamp_utc(int64_t timestamp, struct tm* tm_out)
{
  time_t sec;

  if (tm_out == NULL) {
    return -1;
  }

  sec = (time_t)timestamp;
  return (gmtime_r(&sec, tm_out) != NULL) ? 0 : -1;
}

int 
${namespace}_date_from_timestamp_local(int64_t timestamp, struct tm* tm_out)
{
  time_t sec;

  if (tm_out == NULL) {
    return -1;
  }

  sec = (time_t)timestamp;
  return (localtime_r(&sec, tm_out) != NULL) ? 0 : -1;
}

int 
${namespace}_date_parse(const char* str, const char* format, struct tm* tm_out)
{
  const char* rem;

  if (str == NULL || format == NULL || tm_out == NULL) {
    return -1;
  }

  ${namespace}_mem_set(tm_out, 0, sizeof(struct tm));
  tm_out->tm_isdst = -1;

  rem = strptime(str, format, tm_out);
  if (rem == NULL) {
    return -1;
  }

  return 0;
}

int 
${namespace}_date_format(const struct tm* tm_in, const char* format, char* buf, size_t buf_size)
{
  size_t written;

  if (tm_in == NULL || format == NULL || buf == NULL || buf_size == 0) {
    return -1;
  }

  written = strftime(buf, buf_size, format, tm_in);
  if (written == 0) {
    return -1;
  }

  return (int)written;
}

int 
${namespace}_date_is_leap_year(int full_year)
{
  return (full_year % 4 == 0 && full_year % 100 != 0) || (full_year % 400 == 0);
}

int 
${namespace}_date_is_valid(const struct tm* tm_in)
{
  static const int days_in_month[] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
  int full_year;
  int max_days;

  if (tm_in == NULL) {
    return 0;
  }

  if (tm_in->tm_mon < 0 || tm_in->tm_mon > 11) {
    return 0;
  }

  full_year = tm_in->tm_year + 1900;
  max_days = days_in_month[tm_in->tm_mon];

  if (tm_in->tm_mon == 1 && ${namespace}_date_is_leap_year(full_year)) {
    max_days = 29;
  }

  if (tm_in->tm_mday < 1 || tm_in->tm_mday > max_days) {
    return 0;
  }

  if (tm_in->tm_hour < 0 || tm_in->tm_hour > 23 ||
      tm_in->tm_min < 0 || tm_in->tm_min > 59 ||
      tm_in->tm_sec < 0 || tm_in->tm_sec > 60) {
    return 0;
  }

  return 1;
}

int 
${namespace}_date_add_days(struct tm* tm_io, int days)
{
  if (tm_io == NULL) {
    return -1;
  }

  tm_io->tm_mday += days;
  tm_io->tm_isdst = -1;

  if (mktime(tm_io) == (time_t)-1) {
    return -1;
  }

  return 0;
}

int64_t 
${namespace}_date_diff_seconds(const struct tm* tm1, const struct tm* tm2)
{
  int64_t ts1;
  int64_t ts2;

  ts1 = ${namespace}_date_to_timestamp_utc(tm1);
  ts2 = ${namespace}_date_to_timestamp_utc(tm2);

  if (ts1 == -1 || ts2 == -1) {
    return 0;
  }

  return ts1 - ts2;
}