/* ================================================================================================================== */
#pragma mark Logging

/**
 * To perform logging, use any of the following function calls in your code:
 *
 *		LogTrace(fmt, ...)	- recommended for detailed tracing of program flow
 *							- will print if LOGGING_LEVEL_TRACE is set on.
 *
 *		LogInfo(fmt, ...)	- recommended for general, infrequent, information messages
 *							- will print if LOGGING_LEVEL_INFO is set on.
 *
 *		LogError(fmt, ...)	- recommended for use only when there is an error to be logged
 *							- will print if LOGGING_LEVEL_ERROR is set on.
 *
 *		LogDebug(fmt, ...)	- recommended for temporary use during debugging
 *							- will print if LOGGING_LEVEL_DEBUG is set on.
 */

/**
 * Set this switch to  enable or disable logging capabilities.
 */
#ifndef LOGGING_ENABLED
#	define LOGGING_ENABLED		1
#endif

/**
 * Set any or all of these switches to enable or disable logging at specific levels.
 * For these settings to be effective, LOGGING_ENABLED must also be defined and non-zero.
 */
#ifndef LOGGING_LEVEL_TRACE
#	define LOGGING_LEVEL_TRACE		1
#endif
#ifndef LOGGING_LEVEL_INFO
#	define LOGGING_LEVEL_INFO		1
#endif
#ifndef LOGGING_LEVEL_ERROR
#	define LOGGING_LEVEL_ERROR		1
#endif
#ifndef LOGGING_LEVEL_DEBUG
#	define LOGGING_LEVEL_DEBUG		0
#endif

/**
 * Set this switch to indicate whether or not to include class, method and line information
 * in the log entries. This can be set either here or as a compiler build setting.
 */
#ifndef LOGGING_INCLUDE_CODE_LOCATION
#define LOGGING_INCLUDE_CODE_LOCATION	1
#endif

// *********** END OF USER SETTINGS  - Do not change anything below this line ***********


#if !(defined(LOGGING_ENABLED) && LOGGING_ENABLED)
#undef LOGGING_LEVEL_TRACE
#undef LOGGING_LEVEL_INFO
#undef LOGGING_LEVEL_ERROR
#undef LOGGING_LEVEL_DEBUG
#endif

// Logging format
#define LOG_FORMAT_NO_LOCATION(fmt, lvl, ...) NSLog((@"[%@] " fmt), lvl, ##__VA_ARGS__)
#define LOG_FORMAT_WITH_LOCATION(fmt, lvl, ...) NSLog((@"%s[Line %d] [%@] " fmt), __PRETTY_FUNCTION__, __LINE__, lvl, ##__VA_ARGS__)

#if defined(LOGGING_INCLUDE_CODE_LOCATION) && LOGGING_INCLUDE_CODE_LOCATION
#define LOG_FORMAT(fmt, lvl, ...) LOG_FORMAT_WITH_LOCATION(fmt, lvl, ##__VA_ARGS__)
#else
#define LOG_FORMAT(fmt, lvl, ...) LOG_FORMAT_NO_LOCATION(fmt, lvl, ##__VA_ARGS__)
#endif

// Trace logging - for detailed tracing
#if defined(LOGGING_LEVEL_TRACE) && LOGGING_LEVEL_TRACE
#define LogTrace(fmt, ...) LOG_FORMAT(fmt, @"trace", ##__VA_ARGS__)
#else
#define LogTrace(...)
#endif

// Info logging - for general, non-performance affecting information messages
#if defined(LOGGING_LEVEL_INFO) && LOGGING_LEVEL_INFO
#define LogInfo(fmt, ...) LOG_FORMAT(fmt, @"info", ##__VA_ARGS__)
#else
#define LogInfo(...)
#endif

// Error logging - only when there is an error to be logged
#if defined(LOGGING_LEVEL_ERROR) && LOGGING_LEVEL_ERROR
#define LogError(fmt, ...) LOG_FORMAT(fmt, @"***ERROR***", ##__VA_ARGS__)
#else
#define LogError(...)
#endif

// Debug logging - use only temporarily for highlighting and tracking down problems
#if defined(LOGGING_LEVEL_DEBUG) && LOGGING_LEVEL_DEBUG
#define LogDebug(fmt, ...) LOG_FORMAT(fmt, @"DEBUG", ##__VA_ARGS__)
#else
#define LogDebug(...)
#endif
