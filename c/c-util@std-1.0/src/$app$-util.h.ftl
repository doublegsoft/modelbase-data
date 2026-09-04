<#import "/$/modelbase.ftl" as modelbase>
<#if license??>
${c.license(license)}
</#if>

#ifndef __${app.name?upper_case}_UTIL_H__
#define __${app.name?upper_case}_UTIL_H__

#ifdef __cplusplus
extern "C" {
#endif

#include <stddef.h>
#include <stdint.h> 
#include <sys/types.h>
#include <time.h>

/*!
** @brief Allocates dynamic memory of the specified size.
** @param size Number of bytes to allocate.
** @return Pointer to the allocated memory, or NULL if allocation fails.
*/
void* 
${namespace}_mem_alloc(size_t size);

/*!
** @brief Allocates dynamic memory for an array of elements and zeroes it out.
** @param count Number of elements.
** @param size Size of each element in bytes.
** @return Pointer to the allocated zeroed memory, or NULL if allocation fails.
*/
void* 
${namespace}_mem_calloc(size_t count, size_t size);

/*!
** @brief Resizes a previously allocated memory block.
** @param ptr Pointer to the previously allocated memory block (can be NULL).
** @param size New size in bytes.
** @return Pointer to the reallocated memory, or NULL if reallocation fails.
*/
void* 
${namespace}_mem_realloc(void* ptr, size_t size);

/*!
** @brief Frees allocated memory.
** @param ptr Pointer to the memory block to free (can be NULL).
*/
void 
${namespace}_mem_free(void* ptr);

/*!
** @brief Fills a block of memory with a specific byte value.
** @param dst Pointer to the destination memory block.
** @param value Byte value to set.
** @param size Number of bytes to set.
*/
void 
${namespace}_mem_set(void* dst, int value, size_t size);

/*!
** @brief Copies bytes between non-overlapping memory regions.
** @param dst Pointer to destination buffer.
** @param src Pointer to source buffer.
** @param size Number of bytes to copy.
*/
void 
${namespace}_mem_copy(void* dst, const void* src, size_t size);

/*!
** @brief Copies bytes between potentially overlapping memory regions.
** @param dst Pointer to destination buffer.
** @param src Pointer to source buffer.
** @param size Number of bytes to move.
*/
void 
${namespace}_mem_move(void* dst, const void* src, size_t size);

/*!
** @brief Compares two blocks of memory byte by byte.
** @param a Pointer to the first memory block.
** @param b Pointer to the second memory block.
** @param size Number of bytes to compare.
** @return < 0 if a < b, 0 if a == b, > 0 if a > b.
*/
int 
${namespace}_mem_compare(const void* a, const void* b, size_t size);

/*!
** @brief Calculates the length of a null-terminated string (safe for NULL).
** @param str Input string.
** @return Length of string, or 0 if `str` is NULL.
*/
size_t 
${namespace}_str_length(const char* str);

/*!
** @brief Compares two null-terminated strings (NULL-safe).
** @param a First string.
** @param b Second string.
** @return 0 if equal, negative if a < b, positive if a > b (NULL is treated as smaller).
*/
int 
${namespace}_str_compare(const char* a, const char* b);

/*!
** @brief Checks if two strings are equal.
** @param a First string.
** @param b Second string.
** @return 1 if strings are equal, 0 otherwise.
*/
int 
${namespace}_str_equal(const char* a, const char* b);

/*!
** @brief Copies a string to destination (NULL-safe).
** @param dst Destination buffer.
** @param src Source null-terminated string.
** @return Pointer to dst, or NULL on error.
*/
char* 
${namespace}_str_copy(char* dst, const char* src);

/*!
** @brief Duplicates a string using dynamic memory allocation (`${namespace}_mem_alloc`).
** @param str String to duplicate.
** @return Pointer to newly allocated duplicate string, or NULL on failure/NULL input.
*/
char* 
${namespace}_str_duplicate(const char* str);

/*!
** @brief Finds the first occurrence of a character in a string.
** @param str Input string.
** @param value Character to search for.
** @return Pointer to the located character, or NULL if not found or str is NULL.
*/
const 
char* ${namespace}_str_find(const char* str, int value);

/*!
** @brief Checks if a string starts with a given prefix.
** @param str Input string.
** @param prefix Prefix to check.
** @return 1 if `str` starts with `prefix`, 0 otherwise.
*/
int 
${namespace}_str_prefix(const char* str, const char* prefix);

/*!
** @brief Checks if a string ends with a given suffix.
** @param str Input string.
** @param suffix Suffix to check.
** @return 1 if `str` ends with `suffix`, 0 otherwise.
*/
int 
${namespace}_str_suffix(const char* str, const char* suffix);

/*!
** @brief Gets current epoch time in milliseconds.
** @return Milliseconds since UNIX epoch.
*/
int64_t 
${namespace}_time_millis(void);

/*!
** @brief Sets socket send and receive timeouts.
** @param fd Socket file descriptor.
** @param timeout_ms Timeout in milliseconds.
** @return 0 on success, -1 on error.
*/
int 
${namespace}_net_set_timeout(int fd, int timeout_ms);

/*!
** @brief Resolves hostname and establishes a TCP connection with a timeout.
** @param host Hostname or IP address string.
** @param port Port number.
** @param timeout_ms Socket send/receive timeout in milliseconds.
** @return Connected socket file descriptor on success, -1 on failure.
*/
int 
${namespace}_net_connect(const char* host, uint16_t port, int timeout_ms);

/*!
** @brief Reads data from a network socket.
** @param fd Socket file descriptor.
** @param data Buffer to store received data.
** @param size Maximum number of bytes to read.
** @return Number of bytes read, 0 on peer disconnect, or -1 on error.
*/
ssize_t ${namespace}_net_read(int fd, void* data, size_t size);

/*!
** @brief Sends data to a network socket.
** @param fd Socket file descriptor.
** @param data Buffer containing data to send.
** @param size Number of bytes to send.
** @return Number of bytes sent, or -1 on error.
*/
ssize_t 
${namespace}_net_write(int fd, const void* data, size_t size);

/*!
** @brief Sends all data over a socket, retrying on partial writes and EINTR.
** @param fd Socket file descriptor.
** @param data Buffer containing data to send.
** @param size Total number of bytes to send.
** @return 0 on success, -1 on error.
*/
int 
${namespace}_net_write_all(int fd, const void* data, size_t size);

/*!
** @brief Closes a socket connection.
** @param fd Socket file descriptor.
** @return 0 on success, -1 on error.
*/
int 
${namespace}_net_close(int fd);

/*!
** @brief Gets current UTC time into standard struct tm.
** @param tm_out Pointer to struct tm destination.
** @return 0 on success, -1 on error.
*/
int 
${namespace}_date_now_utc(struct tm* tm_out);

/*!
** @brief Gets current local time into standard struct tm.
** @param tm_out Pointer to struct tm destination.
** @return 0 on success, -1 on error.
*/
int ${namespace}_date_now_local(struct tm* tm_out);

/*!
** @brief Converts struct tm (as UTC) to UNIX timestamp.
** @param tm_in Pointer to struct tm input.
** @return UNIX timestamp in seconds, or -1 on error.
*/
int64_t 
${namespace}_date_to_timestamp_utc(const struct tm* tm_in);

/*!
** @brief Converts struct tm (as local time) to UNIX timestamp.
** @param tm_in Pointer to struct tm input.
** @return UNIX timestamp in seconds, or -1 on error.
*/
int64_t 
${namespace}_date_to_timestamp_local(struct tm* tm_in);

/*!
** @brief Converts a UNIX timestamp to UTC struct tm.
** @param timestamp UNIX timestamp (seconds since 1970-01-01).
** @param tm_out Pointer to struct tm destination.
** @return 0 on success, -1 on error.
*/
int 
${namespace}_date_from_timestamp_utc(int64_t timestamp, struct tm* tm_out);

/*!
** @brief Converts a UNIX timestamp to local timezone struct tm.
** @param timestamp UNIX timestamp (seconds since 1970-01-01).
** @param tm_out Pointer to struct tm destination.
** @return 0 on success, -1 on error.
*/
int 
${namespace}_date_from_timestamp_local(int64_t timestamp, struct tm* tm_out);

/*!
** @brief Parses a date string into struct tm using strptime format.
** @param str Input date string (e.g. "2026-03-30 15:45:00").
** @param format Format specifier (e.g. "%Y-%m-%d %H:%M:%S").
** @param tm_out Pointer to output struct tm.
** @return 0 on success, -1 on parse failure.
*/
int 
${namespace}_date_parse(const char* str, const char* format, struct tm* tm_out);

/*!
** @brief Formats struct tm into a string buffer using strftime format.
** @param tm_in Pointer to struct tm input.
** @param format Format specifier (e.g. "%Y-%m-%d %H:%M:%S").
** @param buf Output string buffer.
** @param buf_size Size of the output buffer.
** @return Number of bytes written, or -1 on failure.
*/
int 
${namespace}_date_format(const struct tm* tm_in, const char* format, char* buf, size_t buf_size);
/*!
** @brief Checks if a given year is a leap year.
** @param full_year Full year (e.g. 2026).
** @return 1 if leap year, 0 otherwise.
*/
int 
${namespace}_date_is_leap_year(int full_year);

/*!
** @brief Validates if the struct tm holds valid calendar values.
** @param tm_in Pointer to struct tm to validate.
** @return 1 if valid, 0 otherwise.
*/
int 
${namespace}_date_is_valid(const struct tm* tm_in);

/*!
** @brief Adds or subtracts days from a struct tm (automatically handles month/year roll-over).
** @param tm_io Pointer to struct tm to modify.
** @param days Number of days to add (can be negative).
** @return 0 on success, -1 on error.
*/
int 
${namespace}_date_add_days(struct tm* tm_io, int days);

/*!
** @brief Calculates difference in seconds between two struct tm (tm1 - tm2).
** @param tm1 First struct tm.
** @param tm2 Second struct tm.
** @return Difference in seconds.
*/
int64_t 
${namespace}_date_diff_seconds(const struct tm* tm1, const struct tm* tm2);

#ifdef __cplusplus
}
#endif

#endif // __${app.name?upper_case}_UTIL_H__
