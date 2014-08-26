import logging

cdef extern from "stdarg.h":
	ctypedef struct va_list

cdef extern from "stdio.h":
	int vsnprintf(char* s, size_t n, const char* format, va_list arg)

from pylinphone.linphone.lib.ortp.ortp cimport OrtpLogLevel, ORTP_DEBUG, ORTP_MESSAGE, \
	ORTP_WARNING, ORTP_ERROR, ORTP_FATAL

_LOG_TAG = 'Linphone'

cpdef linphone_logget_set_tag(str tag):
	global _LOG_TAG
	_LOG_TAG = tag

cdef void linphone_logger(OrtpLogLevel lev, const char* fmt, va_list args):
	cdef char[4096] msg
	cdef str level = 'critical'
	vsnprintf(msg, sizeof(msg) - 1, fmt, args)
	msg[sizeof(msg) - 1] = '\0'
	
	if lev == ORTP_DEBUG:
		level = 'debug'
	elif lev == ORTP_MESSAGE:
		level = 'info'
	elif lev == ORTP_WARNING:
		level = 'warning'
	elif lev == ORTP_ERROR:
		level = 'error'
	elif lev == ORTP_FATAL:
		level = 'critical'
	
	getattr(logging.getLogger(_LOG_TAG), level)(str(msg))
	
	