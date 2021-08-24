sqlext.h   [plain text]
/*
 *  sqlext.h
 *
 *  $Id: sqlext.h,v 1.10 2006/01/20 15:58:34 source Exp $
 *
 *  ODBC defines (ext)
 *
 *  The iODBC driver manager.
 *
 *  Copyright (C) 1995 by Ke Jin <kejin@empress.com>
 *  Copyright (C) 1996-2006 by OpenLink Software <iodbc@openlinksw.com>
 *  All Rights Reserved.
 *
 *  This software is released under the terms of either of the following
 *  licenses:
 *
 *      - GNU Library General Public License (see LICENSE.LGPL)
 *      - The BSD License (see LICENSE.BSD).
 *
 *  Note that the only valid version of the LGPL license as far as this
 *  project is concerned is the original GNU Library General Public License
 *  Version 2, dated June 1991.
 *
 *  While not mandated by the BSD license, any patches you make to the
 *  iODBC source code may be contributed back into the iODBC project
 *  at your discretion. Contributions will benefit the Open Source and
 *  Data Access community as a whole. Submissions may be made at:
 *
 *      http://www.iodbc.org
 *
 *
 *  GNU Library Generic Public License Version 2
 *  ============================================
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Library General Public
 *  License as published by the Free Software Foundation; only
 *  Version 2 of the License dated June 1991.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Library General Public License for more details.
 *
 *  You should have received a copy of the GNU Library General Public
 *  License along with this library; if not, write to the Free
 *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *
 *
 *  The BSD License
 *  ===============
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions
 *  are met:
 *
 *  1. Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *  2. Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *  3. Neither the name of OpenLink Software Inc. nor the names of its
 *     contributors may be used to endorse or promote products derived
 *     from this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 *  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL OPENLINK OR
 *  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 *  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 *  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 *  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#ifndef _SQLEXT_H
#define _SQLEXT_H

#ifndef _SQL_H
#include <sql.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif


/*
 *  Useful Constants
 */
#define SQL_SPEC_MAJOR              3
#define SQL_SPEC_MINOR              52
#define SQL_SPEC_STRING             "03.52"

#define SQL_SQLSTATE_SIZE           5
#define SQL_MAX_DSN_LENGTH          32
#define SQL_MAX_OPTION_STRING_LENGTH        256


/*
 *  Handle types
 */
#if (ODBCVER >= 0x0300)
#define SQL_HANDLE_SENV             5
#endif  /* ODBCVER >= 0x0300 */


/*
 *  Function return codes
 */
#if (ODBCVER < 0x0300)
#define SQL_NO_DATA_FOUND           100
#else
#define SQL_NO_DATA_FOUND           SQL_NO_DATA
#endif  /* ODBCVER < 0x0300 */


/*
 *  Special length values for attributes
 */
#if (ODBCVER >= 0x0300)
#define SQL_IS_POINTER              (-4)
#define SQL_IS_UINTEGER             (-5)
#define SQL_IS_INTEGER              (-6)
#define SQL_IS_USMALLINT            (-7)
#define SQL_IS_SMALLINT             (-8)
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQL extended datatypes
 */
#define SQL_DATE                9
#if (ODBCVER >= 0x0300)
#define SQL_INTERVAL                10
#endif  /* ODBCVER >= 0x0300 */
#define SQL_TIME                10
#define SQL_TIMESTAMP               11
#define SQL_LONGVARCHAR             (-1)
#define SQL_BINARY              (-2)
#define SQL_VARBINARY               (-3)
#define SQL_LONGVARBINARY           (-4)
#define SQL_BIGINT              (-5)
#define SQL_TINYINT             (-6)
#define SQL_BIT                 (-7)
#if (ODBCVER >= 0x0350)
#define SQL_GUID                (-11)
#endif  /* ODBCVER >= 0x0350 */


/*
 *  SQL Interval datatypes
 */
#if (ODBCVER >= 0x0300)
#define SQL_CODE_YEAR               1
#define SQL_CODE_MONTH              2
#define SQL_CODE_DAY                3
#define SQL_CODE_HOUR               4
#define SQL_CODE_MINUTE             5
#define SQL_CODE_SECOND             6
#define SQL_CODE_YEAR_TO_MONTH          7
#define SQL_CODE_DAY_TO_HOUR            8
#define SQL_CODE_DAY_TO_MINUTE          9
#define SQL_CODE_DAY_TO_SECOND          10
#define SQL_CODE_HOUR_TO_MINUTE         11
#define SQL_CODE_HOUR_TO_SECOND         12
#define SQL_CODE_MINUTE_TO_SECOND       13

#define SQL_INTERVAL_YEAR           (100 + SQL_CODE_YEAR)
#define SQL_INTERVAL_MONTH          (100 + SQL_CODE_MONTH)
#define SQL_INTERVAL_DAY            (100 + SQL_CODE_DAY)
#define SQL_INTERVAL_HOUR           (100 + SQL_CODE_HOUR)
#define SQL_INTERVAL_MINUTE         (100 + SQL_CODE_MINUTE)
#define SQL_INTERVAL_SECOND                 (100 + SQL_CODE_SECOND)
#define SQL_INTERVAL_YEAR_TO_MONTH      (100 + SQL_CODE_YEAR_TO_MONTH)
#define SQL_INTERVAL_DAY_TO_HOUR        (100 + SQL_CODE_DAY_TO_HOUR)
#define SQL_INTERVAL_DAY_TO_MINUTE      (100 + SQL_CODE_DAY_TO_MINUTE)
#define SQL_INTERVAL_DAY_TO_SECOND      (100 + SQL_CODE_DAY_TO_SECOND)
#define SQL_INTERVAL_HOUR_TO_MINUTE     (100 + SQL_CODE_HOUR_TO_MINUTE)
#define SQL_INTERVAL_HOUR_TO_SECOND     (100 + SQL_CODE_HOUR_TO_SECOND)
#define SQL_INTERVAL_MINUTE_TO_SECOND       (100 + SQL_CODE_MINUTE_TO_SECOND)
#else
#define SQL_INTERVAL_YEAR           (-80)
#define SQL_INTERVAL_MONTH          (-81)
#define SQL_INTERVAL_YEAR_TO_MONTH      (-82)
#define SQL_INTERVAL_DAY            (-83)
#define SQL_INTERVAL_HOUR           (-84)
#define SQL_INTERVAL_MINUTE         (-85)
#define SQL_INTERVAL_SECOND         (-86)
#define SQL_INTERVAL_DAY_TO_HOUR        (-87)
#define SQL_INTERVAL_DAY_TO_MINUTE      (-88)
#define SQL_INTERVAL_DAY_TO_SECOND      (-89)
#define SQL_INTERVAL_HOUR_TO_MINUTE     (-90)
#define SQL_INTERVAL_HOUR_TO_SECOND     (-91)
#define SQL_INTERVAL_MINUTE_TO_SECOND       (-92)
#endif  /* ODBCVER >= 0x0300 */


/*
 *   SQL unicode data types
 */
#if (ODBCVER <= 0x0300)
/* These definitions are historical and obsolete */
#define SQL_UNICODE             (-95)
#define SQL_UNICODE_VARCHAR         (-96)
#define SQL_UNICODE_LONGVARCHAR         (-97)
#define SQL_UNICODE_CHAR            SQL_UNICODE
#else
#define SQL_UNICODE             SQL_WCHAR
#define SQL_UNICODE_VARCHAR         SQL_WVARCHAR
#define SQL_UNICODE_LONGVARCHAR         SQL_WLONGVARCHAR
#define SQL_UNICODE_CHAR            SQL_WCHAR
#endif  /* ODBCVER >= 0x0300 */


#if (ODBCVER < 0x0300)
#define SQL_TYPE_DRIVER_START           SQL_INTERVAL_YEAR
#define SQL_TYPE_DRIVER_END         SQL_UNICODE_LONGVARCHAR
#endif  /* ODBCVER < 0x0300 */


#define SQL_SIGNED_OFFSET           (-20)
#define SQL_UNSIGNED_OFFSET         (-22)


/*
 *  C datatype to SQL datatype mapping
 */
#define SQL_C_CHAR                  SQL_CHAR
#define SQL_C_LONG                  SQL_INTEGER
#define SQL_C_SHORT                 SQL_SMALLINT
#define SQL_C_FLOAT                 SQL_REAL
#define SQL_C_DOUBLE                SQL_DOUBLE
#if (ODBCVER >= 0x0300)
#define SQL_C_NUMERIC               SQL_NUMERIC
#endif   /* ODBCVER >= 0x0300 */
#define SQL_C_DEFAULT               99


#define SQL_C_DATE              SQL_DATE
#define SQL_C_TIME              SQL_TIME
#define SQL_C_TIMESTAMP             SQL_TIMESTAMP
#define SQL_C_BINARY                SQL_BINARY
#define SQL_C_BIT               SQL_BIT
#define SQL_C_TINYINT               SQL_TINYINT
#define SQL_C_SLONG             (SQL_C_LONG+SQL_SIGNED_OFFSET)
#define SQL_C_SSHORT                (SQL_C_SHORT+SQL_SIGNED_OFFSET)
#define SQL_C_STINYINT              (SQL_TINYINT+SQL_SIGNED_OFFSET)
#define SQL_C_ULONG             (SQL_C_LONG+SQL_UNSIGNED_OFFSET)
#define SQL_C_USHORT                (SQL_C_SHORT+SQL_UNSIGNED_OFFSET)
#define SQL_C_UTINYINT              (SQL_TINYINT+SQL_UNSIGNED_OFFSET)

#if defined(_WIN64)
#define SQL_C_BOOKMARK              SQL_C_UBIGINT
#else
#define SQL_C_BOOKMARK              SQL_C_ULONG
#endif

#if (ODBCVER >= 0x0300)
#define SQL_C_TYPE_DATE             SQL_TYPE_DATE
#define SQL_C_TYPE_TIME             SQL_TYPE_TIME
#define SQL_C_TYPE_TIMESTAMP            SQL_TYPE_TIMESTAMP
#define SQL_C_INTERVAL_YEAR         SQL_INTERVAL_YEAR
#define SQL_C_INTERVAL_MONTH            SQL_INTERVAL_MONTH
#define SQL_C_INTERVAL_DAY          SQL_INTERVAL_DAY
#define SQL_C_INTERVAL_HOUR         SQL_INTERVAL_HOUR
#define SQL_C_INTERVAL_MINUTE           SQL_INTERVAL_MINUTE
#define SQL_C_INTERVAL_SECOND           SQL_INTERVAL_SECOND
#define SQL_C_INTERVAL_YEAR_TO_MONTH        SQL_INTERVAL_YEAR_TO_MONTH
#define SQL_C_INTERVAL_DAY_TO_HOUR      SQL_INTERVAL_DAY_TO_HOUR
#define SQL_C_INTERVAL_DAY_TO_MINUTE        SQL_INTERVAL_DAY_TO_MINUTE
#define SQL_C_INTERVAL_DAY_TO_SECOND        SQL_INTERVAL_DAY_TO_SECOND
#define SQL_C_INTERVAL_HOUR_TO_MINUTE       SQL_INTERVAL_HOUR_TO_MINUTE
#define SQL_C_INTERVAL_HOUR_TO_SECOND       SQL_INTERVAL_HOUR_TO_SECOND
#define SQL_C_INTERVAL_MINUTE_TO_SECOND     SQL_INTERVAL_MINUTE_TO_SECOND
#define SQL_C_SBIGINT               (SQL_BIGINT+SQL_SIGNED_OFFSET)
#define SQL_C_UBIGINT               (SQL_BIGINT+SQL_UNSIGNED_OFFSET)
#define SQL_C_VARBOOKMARK           SQL_C_BINARY
#endif   /* ODBCVER >= 0x0300 */

#if (ODBCVER >= 0x0350)
#define SQL_C_GUID              SQL_GUID
#endif

#define SQL_TYPE_NULL               0

#if (ODBCVER < 0x0300)
#define SQL_TYPE_MIN                SQL_BIT
#define SQL_TYPE_MAX                SQL_VARCHAR
#endif  /* ODBCVER < 0x0300 */


/*
 * ----------------------------------------------------------------------
 *  Level 1 Functions
 * ----------------------------------------------------------------------
 */

/*
 *  SQLBindParameter
 */
#define SQL_DEFAULT_PARAM           (-5)
#define SQL_IGNORE              (-6)
#if (ODBCVER >= 0x0300)
#define SQL_COLUMN_IGNORE           SQL_IGNORE
#endif  /* ODBCVER >= 0x0300 */
#define SQL_LEN_DATA_AT_EXEC_OFFSET     (-100)
#define SQL_LEN_DATA_AT_EXEC(length)        (-(length)+SQL_LEN_DATA_AT_EXEC_OFFSET)


/*
 *  binary length for driver specific attributes
 */
#define SQL_LEN_BINARY_ATTR_OFFSET       (-100)
#define SQL_LEN_BINARY_ATTR(length)  (-(length)+SQL_LEN_BINARY_ATTR_OFFSET)


/*
 *  SQLColAttributes - ODBC 2.x defines
 */
#define SQL_COLUMN_COUNT            0
#define SQL_COLUMN_NAME             1
#define SQL_COLUMN_TYPE             2
#define SQL_COLUMN_LENGTH           3
#define SQL_COLUMN_PRECISION            4
#define SQL_COLUMN_SCALE            5
#define SQL_COLUMN_DISPLAY_SIZE         6
#define SQL_COLUMN_NULLABLE         7
#define SQL_COLUMN_UNSIGNED         8
#define SQL_COLUMN_MONEY            9
#define SQL_COLUMN_UPDATABLE            10
#define SQL_COLUMN_AUTO_INCREMENT       11
#define SQL_COLUMN_CASE_SENSITIVE       12
#define SQL_COLUMN_SEARCHABLE           13
#define SQL_COLUMN_TYPE_NAME            14
#define SQL_COLUMN_TABLE_NAME           15
#define SQL_COLUMN_OWNER_NAME           16
#define SQL_COLUMN_QUALIFIER_NAME       17
#define SQL_COLUMN_LABEL            18
#define SQL_COLATT_OPT_MAX          SQL_COLUMN_LABEL
#if (ODBCVER < 0x0300)
#define SQL_COLUMN_DRIVER_START         1000
#endif  /* ODBCVER < 0x0300 */

#define SQL_COLATT_OPT_MIN          SQL_COLUMN_COUNT


/*
 *  SQLColAttributes - SQL_COLUMN_UPDATABLE
 */
#define SQL_ATTR_READONLY           0
#define SQL_ATTR_WRITE              1
#define SQL_ATTR_READWRITE_UNKNOWN      2


/*
 *  SQLColAttributes - SQL_COLUMN_SEARCHABLE
 */
#define SQL_UNSEARCHABLE            0
#define SQL_LIKE_ONLY               1
#define SQL_ALL_EXCEPT_LIKE         2
#define SQL_SEARCHABLE              3
#define SQL_PRED_SEARCHABLE         SQL_SEARCHABLE


/*
 *  SQLDataSources - additional fetch directions
 */
#if (ODBCVER >= 0x0300)
#define SQL_FETCH_FIRST_USER            31
#define SQL_FETCH_FIRST_SYSTEM          32
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLDriverConnect
 */
#define SQL_DRIVER_NOPROMPT         0
#define SQL_DRIVER_COMPLETE         1
#define SQL_DRIVER_PROMPT           2
#define SQL_DRIVER_COMPLETE_REQUIRED        3


/*
 *  SQLGetConnectAttr - ODBC 2.x attributes
 */
#define SQL_ACCESS_MODE             101
#define SQL_AUTOCOMMIT              102
#define SQL_LOGIN_TIMEOUT           103
#define SQL_OPT_TRACE               104
#define SQL_OPT_TRACEFILE           105
#define SQL_TRANSLATE_DLL           106
#define SQL_TRANSLATE_OPTION            107
#define SQL_TXN_ISOLATION           108
#define SQL_CURRENT_QUALIFIER           109
#define SQL_ODBC_CURSORS            110
#define SQL_QUIET_MODE              111
#define SQL_PACKET_SIZE             112


/*
 *  SQLGetConnectAttr - ODBC 3.0 attributes
 */
#if (ODBCVER >= 0x0300)
#define SQL_ATTR_ACCESS_MODE            SQL_ACCESS_MODE
#define SQL_ATTR_AUTOCOMMIT         SQL_AUTOCOMMIT
#define SQL_ATTR_CONNECTION_TIMEOUT     113
#define SQL_ATTR_CURRENT_CATALOG        SQL_CURRENT_QUALIFIER
#define SQL_ATTR_DISCONNECT_BEHAVIOR        114
#define SQL_ATTR_ENLIST_IN_DTC          1207
#define SQL_ATTR_ENLIST_IN_XA           1208
#define SQL_ATTR_LOGIN_TIMEOUT          SQL_LOGIN_TIMEOUT
#define SQL_ATTR_ODBC_CURSORS           SQL_ODBC_CURSORS
#define SQL_ATTR_PACKET_SIZE            SQL_PACKET_SIZE
#define SQL_ATTR_QUIET_MODE         SQL_QUIET_MODE
#define SQL_ATTR_TRACE              SQL_OPT_TRACE
#define SQL_ATTR_TRACEFILE          SQL_OPT_TRACEFILE
#define SQL_ATTR_TRANSLATE_LIB          SQL_TRANSLATE_DLL
#define SQL_ATTR_TRANSLATE_OPTION       SQL_TRANSLATE_OPTION
#define SQL_ATTR_TXN_ISOLATION          SQL_TXN_ISOLATION
#endif  /* ODBCVER >= 0x0300 */

#define SQL_ATTR_CONNECTION_DEAD        1209 /* GetConnectAttr only */


/*
 *  These options have no meaning for a 3.0 driver
 */
#if (ODBCVER < 0x0300)
#define SQL_CONN_OPT_MIN            SQL_ACCESS_MODE
#define SQL_CONN_OPT_MAX            SQL_PACKET_SIZE
#define SQL_CONNECT_OPT_DRVR_START      1000
#endif  /* ODBCVER < 0x0300 */


/*
 *  SQLGetConnectAttr - SQL_ACCESS_MODE
 */
#define SQL_MODE_READ_WRITE         0UL
#define SQL_MODE_READ_ONLY          1UL
#define SQL_MODE_DEFAULT            SQL_MODE_READ_WRITE


/*
 *  SQLGetConnectAttr - SQL_AUTOCOMMIT
 */
#define SQL_AUTOCOMMIT_OFF          0UL
#define SQL_AUTOCOMMIT_ON           1UL
#define SQL_AUTOCOMMIT_DEFAULT          SQL_AUTOCOMMIT_ON


/*
 *  SQLGetConnectAttr - SQL_LOGIN_TIMEOUT
 */
#define SQL_LOGIN_TIMEOUT_DEFAULT       15UL


/*
 *  SQLGetConnectAttr - SQL_ODBC_CURSORS
 */
#define SQL_CUR_USE_IF_NEEDED           0UL
#define SQL_CUR_USE_ODBC            1UL
#define SQL_CUR_USE_DRIVER          2UL
#define SQL_CUR_DEFAULT             SQL_CUR_USE_DRIVER


/*
 *  SQLGetConnectAttr - SQL_OPT_TRACE
 */
#define SQL_OPT_TRACE_OFF           0UL
#define SQL_OPT_TRACE_ON            1UL
#define SQL_OPT_TRACE_DEFAULT           SQL_OPT_TRACE_OFF
#if defined (WIN32)
#define SQL_OPT_TRACE_FILE_DEFAULT      "\\SQL.LOG"
#define SQL_OPT_TRACE_FILE_DEFAULTW     L"\\SQL.LOG"
#else
#define SQL_OPT_TRACE_FILE_DEFAULT      "/tmp/odbc.log"
#define SQL_OPT_TRACE_FILE_DEFAULTW     L"/tmp/odbc.log"
#endif


/*
 *  SQLGetConnectAttr - SQL_ATTR_ANSI_APP
 */
#if (ODBCVER >= 0x0351)
#define SQL_AA_TRUE             1L /* ANSI app */
#define SQL_AA_FALSE                0L /* Unicode app */
#endif


/*
 *  SQLGetConnectAttr - SQL_ATTR_CONNECTION_DEAD
 */
#define SQL_CD_TRUE             1L /* closed/dead */
#define SQL_CD_FALSE                0L /* open/available */


/*
 *  SQLGetConnectAttr - SQL_ATTR_DISCONNECT_BEHAVIOR
 */
#if (ODBCVER >= 0x0300)
#define SQL_DB_RETURN_TO_POOL           0UL
#define SQL_DB_DISCONNECT           1UL
#define SQL_DB_DEFAULT              SQL_DB_RETURN_TO_POOL
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetConnectAttr - SQL_ATTR_ENLIST_IN_DTC
 */
#if (ODBCVER >= 0x0300)
#define SQL_DTC_DONE                0L
#endif  /* ODBCVER >= 0x0300 */


/*
 *   SQLGetConnectAttr - Unicode drivers
 */
#if (ODBCVER >= 0x0351)
#define SQL_ATTR_ANSI_APP           115
#endif


/*
 *  SQLGetData
 */
#define SQL_NO_TOTAL                (-4)


/*
 *  SQLGetDescField - extended descriptor field
 */
#if (ODBCVER >= 0x0300)
#define SQL_DESC_ARRAY_SIZE         20
#define SQL_DESC_ARRAY_STATUS_PTR       21
#define SQL_DESC_AUTO_UNIQUE_VALUE      SQL_COLUMN_AUTO_INCREMENT
#define SQL_DESC_BASE_COLUMN_NAME       22
#define SQL_DESC_BASE_TABLE_NAME        23
#define SQL_DESC_BIND_OFFSET_PTR        24
#define SQL_DESC_BIND_TYPE          25
#define SQL_DESC_CASE_SENSITIVE         SQL_COLUMN_CASE_SENSITIVE
#define SQL_DESC_CATALOG_NAME           SQL_COLUMN_QUALIFIER_NAME
#define SQL_DESC_CONCISE_TYPE           SQL_COLUMN_TYPE
#define SQL_DESC_DATETIME_INTERVAL_PRECISION    26
#define SQL_DESC_DISPLAY_SIZE           SQL_COLUMN_DISPLAY_SIZE
#define SQL_DESC_FIXED_PREC_SCALE       SQL_COLUMN_MONEY
#define SQL_DESC_LABEL              SQL_COLUMN_LABEL
#define SQL_DESC_LITERAL_PREFIX         27
#define SQL_DESC_LITERAL_SUFFIX         28
#define SQL_DESC_LOCAL_TYPE_NAME        29
#define SQL_DESC_MAXIMUM_SCALE          30
#define SQL_DESC_MINIMUM_SCALE          31
#define SQL_DESC_NUM_PREC_RADIX         32
#define SQL_DESC_PARAMETER_TYPE         33
#define SQL_DESC_ROWS_PROCESSED_PTR     34
#if (ODBCVER >= 0x0350)
#define SQL_DESC_ROWVER             35
#endif  /* ODBCVER >= 0x0350 */
#define SQL_DESC_SCHEMA_NAME            SQL_COLUMN_OWNER_NAME
#define SQL_DESC_SEARCHABLE         SQL_COLUMN_SEARCHABLE
#define SQL_DESC_TYPE_NAME          SQL_COLUMN_TYPE_NAME
#define SQL_DESC_TABLE_NAME         SQL_COLUMN_TABLE_NAME
#define SQL_DESC_UNSIGNED           SQL_COLUMN_UNSIGNED
#define SQL_DESC_UPDATABLE          SQL_COLUMN_UPDATABLE
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetDiagField - defines for diagnostics fields
 */
#if (ODBCVER >= 0x0300)
#define SQL_DIAG_CURSOR_ROW_COUNT       (-1249)
#define SQL_DIAG_ROW_NUMBER         (-1248)
#define SQL_DIAG_COLUMN_NUMBER          (-1247)
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetDiagField  - SQL_DIAG_ROW_NUMBER and SQL_DIAG_COLUMN_NUMBER
 */
#if (ODBCVER >= 0x0300)
#define SQL_NO_ROW_NUMBER           (-1)
#define SQL_NO_COLUMN_NUMBER            (-1)
#define SQL_ROW_NUMBER_UNKNOWN          (-2)
#define SQL_COLUMN_NUMBER_UNKNOWN       (-2)
#endif


#if (ODBCVER >= 0x0300)
/*
 *  SQLGetEnvAttr - Attributes
 */
#define SQL_ATTR_ODBC_VERSION           200
#define SQL_ATTR_CONNECTION_POOLING     201
#define SQL_ATTR_CP_MATCH           202


/*
 * SQLGetEnvAttr - SQL_ATTR_ODBC_VERSION
 */
#define SQL_OV_ODBC2                2UL
#define SQL_OV_ODBC3                3UL


/*
 *  SQLGetEnvAttr - SQL_ATTR_CONNECTION_POOLING
 */
#define SQL_CP_OFF              0UL
#define SQL_CP_ONE_PER_DRIVER           1UL
#define SQL_CP_ONE_PER_HENV         2UL
#define SQL_CP_DEFAULT              SQL_CP_OFF


/*
 * SQLGetEnvAttr - SQL_ATTR_CP_MATCH
 */
#define SQL_CP_STRICT_MATCH         0UL
#define SQL_CP_RELAXED_MATCH            1UL
#define SQL_CP_MATCH_DEFAULT            SQL_CP_STRICT_MATCH
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetFunctions - extensions to the X/Open specification
 */
#if (ODBCVER >= 0x0300)
#define SQL_API_SQLALLOCHANDLESTD       73
#define SQL_API_SQLBULKOPERATIONS       24
#endif  /* ODBCVER >= 0x0300 */
#define SQL_API_SQLBINDPARAMETER        72
#define SQL_API_SQLBROWSECONNECT        55
#define SQL_API_SQLCOLATTRIBUTES        6
#define SQL_API_SQLCOLUMNPRIVILEGES     56
#define SQL_API_SQLDESCRIBEPARAM        58
#define SQL_API_SQLDRIVERCONNECT        41
#define SQL_API_SQLDRIVERS          71
#define SQL_API_SQLEXTENDEDFETCH        59
#define SQL_API_SQLFOREIGNKEYS          60
#define SQL_API_SQLMORERESULTS          61
#define SQL_API_SQLNATIVESQL            62
#define SQL_API_SQLNUMPARAMS            63
#define SQL_API_SQLPARAMOPTIONS         64
#define SQL_API_SQLPRIMARYKEYS          65
#define SQL_API_SQLPROCEDURECOLUMNS     66
#define SQL_API_SQLPROCEDURES           67
#define SQL_API_SQLSETPOS           68
#define SQL_API_SQLSETSCROLLOPTIONS     69
#define SQL_API_SQLTABLEPRIVILEGES      70


/*
 *  These are not useful anymore as the X/Open specification defines
 *  functions in the 10000 range
 */
#if (ODBCVER < 0x0300)
#define SQL_EXT_API_LAST            SQL_API_SQLBINDPARAMETER
#define SQL_NUM_FUNCTIONS           23
#define SQL_EXT_API_START           40
#define SQL_NUM_EXTENSIONS      (SQL_EXT_API_LAST-SQL_EXT_API_START+1)
#endif  /* ODBCVER < 0x0300 */


/*
 *  SQLGetFunctions - ODBC version 2.x and earlier
 */
#define SQL_API_ALL_FUNCTIONS           0


/*
 *  Loading by ordinal is not supported for 3.0 and above drivers
 */
#define SQL_API_LOADBYORDINAL           199


/*
 *  SQLGetFunctions - SQL_API_ODBC3_ALL_FUNCTIONS
 */
#if (ODBCVER >= 0x0300)
#define SQL_API_ODBC3_ALL_FUNCTIONS     999
#define SQL_API_ODBC3_ALL_FUNCTIONS_SIZE    250

#define SQL_FUNC_EXISTS(pfExists, uwAPI) \
    ((*(((UWORD*) (pfExists)) + ((uwAPI) >> 4)) & (1 << ((uwAPI) & 0x000F))) \
    ? SQL_TRUE : SQL_FALSE)
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - ODBC 2.x extensions to the X/Open standard
 */
#define SQL_INFO_FIRST              0
#define SQL_ACTIVE_CONNECTIONS          0 /* MAX_DRIVER_CONNECTIONS */
#define SQL_ACTIVE_STATEMENTS           1 /* MAX_CONCURRENT_ACTIVITIES */
#define SQL_DRIVER_HDBC             3
#define SQL_DRIVER_HENV             4
#define SQL_DRIVER_HSTMT            5
#define SQL_DRIVER_NAME             6
#define SQL_DRIVER_VER              7
#define SQL_ODBC_API_CONFORMANCE        9
#define SQL_ODBC_VER                10
#define SQL_ROW_UPDATES             11
#define SQL_ODBC_SAG_CLI_CONFORMANCE        12
#define SQL_ODBC_SQL_CONFORMANCE        15
#define SQL_PROCEDURES              21
#define SQL_CONCAT_NULL_BEHAVIOR        22
#define SQL_CURSOR_ROLLBACK_BEHAVIOR        24
#define SQL_EXPRESSIONS_IN_ORDERBY      27
#define SQL_MAX_OWNER_NAME_LEN          32 /* MAX_SCHEMA_NAME_LEN */
#define SQL_MAX_PROCEDURE_NAME_LEN      33
#define SQL_MAX_QUALIFIER_NAME_LEN      34 /* MAX_CATALOG_NAME_LEN */
#define SQL_MULT_RESULT_SETS            36
#define SQL_MULTIPLE_ACTIVE_TXN         37
#define SQL_OUTER_JOINS             38
#define SQL_OWNER_TERM              39
#define SQL_PROCEDURE_TERM          40
#define SQL_QUALIFIER_NAME_SEPARATOR        41
#define SQL_QUALIFIER_TERM          42
#define SQL_SCROLL_OPTIONS          44
#define SQL_TABLE_TERM              45
#define SQL_CONVERT_FUNCTIONS           48
#define SQL_NUMERIC_FUNCTIONS           49
#define SQL_STRING_FUNCTIONS            50
#define SQL_SYSTEM_FUNCTIONS            51
#define SQL_TIMEDATE_FUNCTIONS          52
#define SQL_CONVERT_BIGINT          53
#define SQL_CONVERT_BINARY          54
#define SQL_CONVERT_BIT             55
#define SQL_CONVERT_CHAR            56
#define SQL_CONVERT_DATE            57
#define SQL_CONVERT_DECIMAL         58
#define SQL_CONVERT_DOUBLE          59
#define SQL_CONVERT_FLOAT           60
#define SQL_CONVERT_INTEGER         61
#define SQL_CONVERT_LONGVARCHAR         62
#define SQL_CONVERT_NUMERIC         63
#define SQL_CONVERT_REAL            64
#define SQL_CONVERT_SMALLINT            65
#define SQL_CONVERT_TIME            66
#define SQL_CONVERT_TIMESTAMP           67
#define SQL_CONVERT_TINYINT         68
#define SQL_CONVERT_VARBINARY           69
#define SQL_CONVERT_VARCHAR         70
#define SQL_CONVERT_LONGVARBINARY       71
#define SQL_ODBC_SQL_OPT_IEF            73 /* SQL_INTEGRITY */
#define SQL_CORRELATION_NAME            74
#define SQL_NON_NULLABLE_COLUMNS        75
#define SQL_DRIVER_HLIB             76
#define SQL_DRIVER_ODBC_VER         77
#define SQL_LOCK_TYPES              78
#define SQL_POS_OPERATIONS          79
#define SQL_POSITIONED_STATEMENTS       80
#define SQL_BOOKMARK_PERSISTENCE        82
#define SQL_STATIC_SENSITIVITY          83
#define SQL_FILE_USAGE              84
#define SQL_COLUMN_ALIAS            87
#define SQL_GROUP_BY                88
#define SQL_KEYWORDS                89
#define SQL_OWNER_USAGE             91
#define SQL_QUALIFIER_USAGE         92
#define SQL_QUOTED_IDENTIFIER_CASE      93
#define SQL_SUBQUERIES              95
#define SQL_UNION               96
#define SQL_MAX_ROW_SIZE_INCLUDES_LONG      103
#define SQL_MAX_CHAR_LITERAL_LEN        108
#define SQL_TIMEDATE_ADD_INTERVALS      109
#define SQL_TIMEDATE_DIFF_INTERVALS     110
#define SQL_NEED_LONG_DATA_LEN          111
#define SQL_MAX_BINARY_LITERAL_LEN      112
#define SQL_LIKE_ESCAPE_CLAUSE          113
#define SQL_QUALIFIER_LOCATION          114

#if (ODBCVER >= 0x0201 && ODBCVER < 0x0300)
#define SQL_OJ_CAPABILITIES         65003  /* Temp value until ODBC 3.0 */
#endif  /* ODBCVER >= 0x0201 && ODBCVER < 0x0300 */


/*
 *  These values are not useful anymore as X/Open defines values in the
 *  10000 range
 */
#if (ODBCVER < 0x0300)
#define SQL_INFO_LAST               SQL_QUALIFIER_LOCATION
#define SQL_INFO_DRIVER_START           1000
#endif  /* ODBCVER < 0x0300 */


/*
 *  SQLGetInfo - ODBC 3.x extensions to the X/Open standard
 */
#if (ODBCVER >= 0x0300)
#define SQL_ACTIVE_ENVIRONMENTS         116
#define SQL_ALTER_DOMAIN            117

#define SQL_SQL_CONFORMANCE         118
#define SQL_DATETIME_LITERALS           119

#define SQL_ASYNC_MODE              10021   /* new X/Open spec */
#define SQL_BATCH_ROW_COUNT         120
#define SQL_BATCH_SUPPORT           121
#define SQL_CATALOG_LOCATION            SQL_QUALIFIER_LOCATION
#define SQL_CATALOG_NAME_SEPARATOR      SQL_QUALIFIER_NAME_SEPARATOR
#define SQL_CATALOG_TERM            SQL_QUALIFIER_TERM
#define SQL_CATALOG_USAGE           SQL_QUALIFIER_USAGE
#define SQL_CONVERT_WCHAR           122
#define SQL_CONVERT_INTERVAL_DAY_TIME       123
#define SQL_CONVERT_INTERVAL_YEAR_MONTH     124
#define SQL_CONVERT_WLONGVARCHAR        125
#define SQL_CONVERT_WVARCHAR            126
#define SQL_CREATE_ASSERTION            127
#define SQL_CREATE_CHARACTER_SET        128
#define SQL_CREATE_COLLATION            129
#define SQL_CREATE_DOMAIN           130
#define SQL_CREATE_SCHEMA           131
#define SQL_CREATE_TABLE            132
#define SQL_CREATE_TRANSLATION          133
#define SQL_CREATE_VIEW             134
#define SQL_DRIVER_HDESC            135
#define SQL_DROP_ASSERTION          136
#define SQL_DROP_CHARACTER_SET          137
#define SQL_DROP_COLLATION          138
#define SQL_DROP_DOMAIN             139
#define SQL_DROP_SCHEMA             140
#define SQL_DROP_TABLE              141
#define SQL_DROP_TRANSLATION            142
#define SQL_DROP_VIEW               143
#define SQL_DYNAMIC_CURSOR_ATTRIBUTES1      144
#define SQL_DYNAMIC_CURSOR_ATTRIBUTES2      145
#define SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES1 146
#define SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES2 147
#define SQL_INDEX_KEYWORDS          148
#define SQL_INFO_SCHEMA_VIEWS           149
#define SQL_KEYSET_CURSOR_ATTRIBUTES1       150
#define SQL_KEYSET_CURSOR_ATTRIBUTES2       151
#define SQL_MAX_ASYNC_CONCURRENT_STATEMENTS 10022   /* new X/Open spec */
#define SQL_ODBC_INTERFACE_CONFORMANCE      152
#define SQL_PARAM_ARRAY_ROW_COUNTS      153
#define SQL_PARAM_ARRAY_SELECTS         154
#define SQL_SCHEMA_TERM             SQL_OWNER_TERM
#define SQL_SCHEMA_USAGE            SQL_OWNER_USAGE
#define SQL_SQL92_DATETIME_FUNCTIONS        155
#define SQL_SQL92_FOREIGN_KEY_DELETE_RULE   156
#define SQL_SQL92_FOREIGN_KEY_UPDATE_RULE   157
#define SQL_SQL92_GRANT             158
#define SQL_SQL92_NUMERIC_VALUE_FUNCTIONS   159
#define SQL_SQL92_PREDICATES            160
#define SQL_SQL92_RELATIONAL_JOIN_OPERATORS 161
#define SQL_SQL92_REVOKE            162
#define SQL_SQL92_ROW_VALUE_CONSTRUCTOR     163
#define SQL_SQL92_STRING_FUNCTIONS      164
#define SQL_SQL92_VALUE_EXPRESSIONS     165
#define SQL_STANDARD_CLI_CONFORMANCE        166
#define SQL_STATIC_CURSOR_ATTRIBUTES1       167
#define SQL_STATIC_CURSOR_ATTRIBUTES2       168

#define SQL_AGGREGATE_FUNCTIONS         169
#define SQL_DDL_INDEX               170
#define SQL_DM_VER              171
#define SQL_INSERT_STATEMENT            172
#define SQL_UNION_STATEMENT         SQL_UNION

#endif  /* ODBCVER >= 0x0300 */

#define SQL_DTC_TRANSITION_COST         1750


/*
 *  SQLGetInfo - SQL_AGGREGATE_FUNCTIONS
 */
#if (ODBCVER >= 0x0300)
#define SQL_AF_AVG              0x00000001L
#define SQL_AF_COUNT                0x00000002L
#define SQL_AF_MAX              0x00000004L
#define SQL_AF_MIN              0x00000008L
#define SQL_AF_SUM              0x00000010L
#define SQL_AF_DISTINCT             0x00000020L
#define SQL_AF_ALL              0x00000040L
#endif  /* ODBCVER >= 0x0300 */

/*
 *  SQLGetInfo - SQL_ALTER_DOMAIN
 */
#if (ODBCVER >= 0x0300)
#define SQL_AD_CONSTRAINT_NAME_DEFINITION   0x00000001L
#define SQL_AD_ADD_DOMAIN_CONSTRAINT        0x00000002L
#define SQL_AD_DROP_DOMAIN_CONSTRAINT       0x00000004L
#define SQL_AD_ADD_DOMAIN_DEFAULT       0x00000008L
#define SQL_AD_DROP_DOMAIN_DEFAULT      0x00000010L
#define SQL_AD_ADD_CONSTRAINT_INITIALLY_DEFERRED    0x00000020L
#define SQL_AD_ADD_CONSTRAINT_INITIALLY_IMMEDIATE   0x00000040L
#define SQL_AD_ADD_CONSTRAINT_DEFERRABLE    0x00000080L
#define SQL_AD_ADD_CONSTRAINT_NON_DEFERRABLE    0x00000100L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_ALTER_TABLE
 */
#if (ODBCVER >= 0x0300)
/*
    * The following 5 bitmasks are defined in sql.h
 *
 * #define SQL_AT_ADD_COLUMN            0x00000001L
 * #define SQL_AT_DROP_COLUMN           0x00000002L
 * #define SQL_AT_ADD_CONSTRAINT        0x00000008L
 */
#define SQL_AT_ADD_COLUMN_SINGLE        0x00000020L
#define SQL_AT_ADD_COLUMN_DEFAULT       0x00000040L
#define SQL_AT_ADD_COLUMN_COLLATION     0x00000080L
#define SQL_AT_SET_COLUMN_DEFAULT       0x00000100L
#define SQL_AT_DROP_COLUMN_DEFAULT      0x00000200L
#define SQL_AT_DROP_COLUMN_CASCADE      0x00000400L
#define SQL_AT_DROP_COLUMN_RESTRICT     0x00000800L
#define SQL_AT_ADD_TABLE_CONSTRAINT     0x00001000L
#define SQL_AT_DROP_TABLE_CONSTRAINT_CASCADE    0x00002000L
#define SQL_AT_DROP_TABLE_CONSTRAINT_RESTRICT   0x00004000L
#define SQL_AT_CONSTRAINT_NAME_DEFINITION   0x00008000L
#define SQL_AT_CONSTRAINT_INITIALLY_DEFERRED    0x00010000L
#define SQL_AT_CONSTRAINT_INITIALLY_IMMEDIATE   0x00020000L
#define SQL_AT_CONSTRAINT_DEFERRABLE        0x00040000L
#define SQL_AT_CONSTRAINT_NON_DEFERRABLE    0x00080000L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_ASYNC_MODE
 */
#if (ODBCVER >= 0x0300)
#define SQL_AM_NONE             0
#define SQL_AM_CONNECTION           1
#define SQL_AM_STATEMENT            2
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_BATCH_ROW_COUNT
 */
#if (ODBCVER >= 0x0300)
#define SQL_BRC_PROCEDURES          0x0000001
#define SQL_BRC_EXPLICIT            0x0000002
#define SQL_BRC_ROLLED_UP           0x0000004
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_BATCH_SUPPORT
 */
#if (ODBCVER >= 0x0300)
#define SQL_BS_SELECT_EXPLICIT          0x00000001L
#define SQL_BS_ROW_COUNT_EXPLICIT       0x00000002L
#define SQL_BS_SELECT_PROC          0x00000004L
#define SQL_BS_ROW_COUNT_PROC           0x00000008L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_BOOKMARK_PERSISTENCE
 */
#define SQL_BP_CLOSE                0x00000001L
#define SQL_BP_DELETE               0x00000002L
#define SQL_BP_DROP             0x00000004L
#define SQL_BP_TRANSACTION          0x00000008L
#define SQL_BP_UPDATE               0x00000010L
#define SQL_BP_OTHER_HSTMT          0x00000020L
#define SQL_BP_SCROLL               0x00000040L


/*
 *  SQLGetInfo - SQL_CATALOG_LOCATION
 */
#if (ODBCVER >= 0x0300)
#define SQL_CL_START                SQL_QL_START
#define SQL_CL_END              SQL_QL_END
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_CATALOG_USAGE
 */
#if (ODBCVER >= 0x0300)
#define SQL_CU_DML_STATEMENTS           SQL_QU_DML_STATEMENTS
#define SQL_CU_PROCEDURE_INVOCATION     SQL_QU_PROCEDURE_INVOCATION
#define SQL_CU_TABLE_DEFINITION         SQL_QU_TABLE_DEFINITION
#define SQL_CU_INDEX_DEFINITION         SQL_QU_INDEX_DEFINITION
#define SQL_CU_PRIVILEGE_DEFINITION     SQL_QU_PRIVILEGE_DEFINITION
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_CONCAT_NULL_BEHAVIOR
 */
#define SQL_CB_NULL             0x0000
#define SQL_CB_NON_NULL             0x0001


/*
 *  SQLGetInfo - SQL_CONVERT_* bitmask values
 */
#define SQL_CVT_CHAR                0x00000001L
#define SQL_CVT_NUMERIC             0x00000002L
#define SQL_CVT_DECIMAL             0x00000004L
#define SQL_CVT_INTEGER             0x00000008L
#define SQL_CVT_SMALLINT            0x00000010L
#define SQL_CVT_FLOAT               0x00000020L
#define SQL_CVT_REAL                0x00000040L
#define SQL_CVT_DOUBLE              0x00000080L
#define SQL_CVT_VARCHAR             0x00000100L
#define SQL_CVT_LONGVARCHAR         0x00000200L
#define SQL_CVT_BINARY              0x00000400L
#define SQL_CVT_VARBINARY           0x00000800L
#define SQL_CVT_BIT             0x00001000L
#define SQL_CVT_TINYINT             0x00002000L
#define SQL_CVT_BIGINT              0x00004000L
#define SQL_CVT_DATE                0x00008000L
#define SQL_CVT_TIME                0x00010000L
#define SQL_CVT_TIMESTAMP           0x00020000L
#define SQL_CVT_LONGVARBINARY           0x00040000L
#if (ODBCVER >= 0x0300)
#define SQL_CVT_INTERVAL_YEAR_MONTH     0x00080000L
#define SQL_CVT_INTERVAL_DAY_TIME       0x00100000L
#define SQL_CVT_WCHAR               0x00200000L
#define SQL_CVT_WLONGVARCHAR            0x00400000L
#define SQL_CVT_WVARCHAR            0x00800000L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_CONVERT_FUNCTIONS
 */
#define SQL_FN_CVT_CONVERT          0x00000001L
#if (ODBCVER >= 0x0300)
#define SQL_FN_CVT_CAST             0x00000002L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_CORRELATION_NAME
 */
#define SQL_CN_NONE             0x0000
#define SQL_CN_DIFFERENT            0x0001
#define SQL_CN_ANY              0x0002


/*
 *  SQLGetInfo - SQL_CREATE_ASSERTION
 */
#if (ODBCVER >= 0x0300)
#define SQL_CA_CREATE_ASSERTION         0x00000001L
#define SQL_CA_CONSTRAINT_INITIALLY_DEFERRED    0x00000010L
#define SQL_CA_CONSTRAINT_INITIALLY_IMMEDIATE   0x00000020L
#define SQL_CA_CONSTRAINT_DEFERRABLE        0x00000040L
#define SQL_CA_CONSTRAINT_NON_DEFERRABLE    0x00000080L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_CREATE_CHARACTER_SET
 */
#if (ODBCVER >= 0x0300)
#define SQL_CCS_CREATE_CHARACTER_SET        0x00000001L
#define SQL_CCS_COLLATE_CLAUSE          0x00000002L
#define SQL_CCS_LIMITED_COLLATION       0x00000004L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_CREATE_COLLATION
 */
#if (ODBCVER >= 0x0300)
#define SQL_CCOL_CREATE_COLLATION       0x00000001L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_CREATE_DOMAIN
 */
#if (ODBCVER >= 0x0300)
#define SQL_CDO_CREATE_DOMAIN           0x00000001L
#define SQL_CDO_DEFAULT             0x00000002L
#define SQL_CDO_CONSTRAINT          0x00000004L
#define SQL_CDO_COLLATION           0x00000008L
#define SQL_CDO_CONSTRAINT_NAME_DEFINITION  0x00000010L
#define SQL_CDO_CONSTRAINT_INITIALLY_DEFERRED   0x00000020L
#define SQL_CDO_CONSTRAINT_INITIALLY_IMMEDIATE  0x00000040L
#define SQL_CDO_CONSTRAINT_DEFERRABLE       0x00000080L
#define SQL_CDO_CONSTRAINT_NON_DEFERRABLE   0x00000100L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_CREATE_SCHEMA
 */
#if (ODBCVER >= 0x0300)
#define SQL_CS_CREATE_SCHEMA            0x00000001L
#define SQL_CS_AUTHORIZATION            0x00000002L
#define SQL_CS_DEFAULT_CHARACTER_SET        0x00000004L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_CREATE_TABLE
 */
#if (ODBCVER >= 0x0300)
#define SQL_CT_CREATE_TABLE         0x00000001L
#define SQL_CT_COMMIT_PRESERVE          0x00000002L
#define SQL_CT_COMMIT_DELETE            0x00000004L
#define SQL_CT_GLOBAL_TEMPORARY         0x00000008L
#define SQL_CT_LOCAL_TEMPORARY          0x00000010L
#define SQL_CT_CONSTRAINT_INITIALLY_DEFERRED    0x00000020L
#define SQL_CT_CONSTRAINT_INITIALLY_IMMEDIATE   0x00000040L
#define SQL_CT_CONSTRAINT_DEFERRABLE        0x00000080L
#define SQL_CT_CONSTRAINT_NON_DEFERRABLE    0x00000100L
#define SQL_CT_COLUMN_CONSTRAINT        0x00000200L
#define SQL_CT_COLUMN_DEFAULT           0x00000400L
#define SQL_CT_COLUMN_COLLATION         0x00000800L
#define SQL_CT_TABLE_CONSTRAINT         0x00001000L
#define SQL_CT_CONSTRAINT_NAME_DEFINITION   0x00002000L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_CREATE_TRANSLATION
 */
#if (ODBCVER >= 0x0300)
#define SQL_CTR_CREATE_TRANSLATION      0x00000001L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_CREATE_VIEW
 */
#define SQL_CV_CREATE_VIEW          0x00000001L
#define SQL_CV_CHECK_OPTION         0x00000002L
#define SQL_CV_CASCADED             0x00000004L
#define SQL_CV_LOCAL                0x00000008L


/*
 *  SQLGetInfo - SQL_DATETIME_LITERALS
 */
#if (ODBCVER >= 0x0300)
#define SQL_DL_SQL92_DATE           0x00000001L
#define SQL_DL_SQL92_TIME           0x00000002L
#define SQL_DL_SQL92_TIMESTAMP          0x00000004L
#define SQL_DL_SQL92_INTERVAL_YEAR      0x00000008L
#define SQL_DL_SQL92_INTERVAL_MONTH     0x00000010L
#define SQL_DL_SQL92_INTERVAL_DAY       0x00000020L
#define SQL_DL_SQL92_INTERVAL_HOUR      0x00000040L
#define SQL_DL_SQL92_INTERVAL_MINUTE        0x00000080L
#define SQL_DL_SQL92_INTERVAL_SECOND        0x00000100L
#define SQL_DL_SQL92_INTERVAL_YEAR_TO_MONTH 0x00000200L
#define SQL_DL_SQL92_INTERVAL_DAY_TO_HOUR   0x00000400L
#define SQL_DL_SQL92_INTERVAL_DAY_TO_MINUTE 0x00000800L
#define SQL_DL_SQL92_INTERVAL_DAY_TO_SECOND 0x00001000L
#define SQL_DL_SQL92_INTERVAL_HOUR_TO_MINUTE    0x00002000L
#define SQL_DL_SQL92_INTERVAL_HOUR_TO_SECOND    0x00004000L
#define SQL_DL_SQL92_INTERVAL_MINUTE_TO_SECOND  0x00008000L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_DDL_INDEX
 */
#if (ODBCVER >= 0x0300)
#define SQL_DI_CREATE_INDEX         0x00000001L
#define SQL_DI_DROP_INDEX           0x00000002L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_DROP_ASSERTION
 */
#if (ODBCVER >= 0x0300)
#define SQL_DA_DROP_ASSERTION           0x00000001L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_DROP_CHARACTER_SET
 */
#if (ODBCVER >= 0x0300)
#define SQL_DCS_DROP_CHARACTER_SET      0x00000001L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_DROP_COLLATION
 */
#if (ODBCVER >= 0x0300)
#define SQL_DC_DROP_COLLATION           0x00000001L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_DROP_DOMAIN
 */
#if (ODBCVER >= 0x0300)
#define SQL_DD_DROP_DOMAIN          0x00000001L
#define SQL_DD_RESTRICT             0x00000002L
#define SQL_DD_CASCADE              0x00000004L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_DROP_SCHEMA
 */
#if (ODBCVER >= 0x0300)
#define SQL_DS_DROP_SCHEMA          0x00000001L
#define SQL_DS_RESTRICT             0x00000002L
#define SQL_DS_CASCADE              0x00000004L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_DROP_TABLE
 */
#if (ODBCVER >= 0x0300)
#define SQL_DT_DROP_TABLE           0x00000001L
#define SQL_DT_RESTRICT             0x00000002L
#define SQL_DT_CASCADE              0x00000004L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_DROP_TRANSLATION
 */
#if (ODBCVER >= 0x0300)
#define SQL_DTR_DROP_TRANSLATION        0x00000001L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_DROP_VIEW
 */
#if (ODBCVER >= 0x0300)
#define SQL_DV_DROP_VIEW            0x00000001L
#define SQL_DV_RESTRICT             0x00000002L
#define SQL_DV_CASCADE              0x00000004L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_DTC_TRANSITION_COST
 */
#define SQL_DTC_ENLIST_EXPENSIVE        0x00000001L
#define SQL_DTC_UNENLIST_EXPENSIVE      0x00000002L


/*
 *  SQLGetInfo - SQL_DYNAMIC_CURSOR_ATTRIBUTES1
 *  SQLGetInfo - SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES1
 *  SQLGetInfo - SQL_KEYSET_CURSOR_ATTRIBUTES1
 *  SQLGetInfo - SQL_STATIC_CURSOR_ATTRIBUTES1
 */
/*
 *  SQLFetchScroll - FetchOrientation
 */
#if (ODBCVER >= 0x0300)
#define SQL_CA1_NEXT                0x00000001L
#define SQL_CA1_ABSOLUTE            0x00000002L
#define SQL_CA1_RELATIVE            0x00000004L
#define SQL_CA1_BOOKMARK            0x00000008L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLSetPos - LockType
 */
#if (ODBCVER >= 0x0300)
#define SQL_CA1_LOCK_NO_CHANGE          0x00000040L
#define SQL_CA1_LOCK_EXCLUSIVE          0x00000080L
#define SQL_CA1_LOCK_UNLOCK         0x00000100L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLSetPos Operations
 */
#if (ODBCVER >= 0x0300)
#define SQL_CA1_POS_POSITION            0x00000200L
#define SQL_CA1_POS_UPDATE          0x00000400L
#define SQL_CA1_POS_DELETE          0x00000800L
#define SQL_CA1_POS_REFRESH         0x00001000L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  positioned updates and deletes
 */
#if (ODBCVER >= 0x0300)
#define SQL_CA1_POSITIONED_UPDATE       0x00002000L
#define SQL_CA1_POSITIONED_DELETE       0x00004000L
#define SQL_CA1_SELECT_FOR_UPDATE       0x00008000L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLBulkOperations operations
 */
#if (ODBCVER >= 0x0300)
#define SQL_CA1_BULK_ADD            0x00010000L
#define SQL_CA1_BULK_UPDATE_BY_BOOKMARK     0x00020000L
#define SQL_CA1_BULK_DELETE_BY_BOOKMARK     0x00040000L
#define SQL_CA1_BULK_FETCH_BY_BOOKMARK      0x00080000L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_DYNAMIC_CURSOR_ATTRIBUTES2
 *  SQLGetInfo - SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES2
 *  SQLGetInfo - SQL_KEYSET_CURSOR_ATTRIBUTES2
 *  SQLGetInfo - SQL_STATIC_CURSOR_ATTRIBUTES2
 */
/*
 *  SQL_ATTR_SCROLL_CONCURRENCY
 */
#if (ODBCVER >= 0x0300)
#define SQL_CA2_READ_ONLY_CONCURRENCY       0x00000001L
#define SQL_CA2_LOCK_CONCURRENCY        0x00000002L
#define SQL_CA2_OPT_ROWVER_CONCURRENCY      0x00000004L
#define SQL_CA2_OPT_VALUES_CONCURRENCY      0x00000008L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  sensitivity of the cursor to its own inserts, deletes, and updates
 */
#if (ODBCVER >= 0x0300)
#define SQL_CA2_SENSITIVITY_ADDITIONS       0x00000010L
#define SQL_CA2_SENSITIVITY_DELETIONS       0x00000020L
#define SQL_CA2_SENSITIVITY_UPDATES     0x00000040L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQL_ATTR_MAX_ROWS
 */
#if (ODBCVER >= 0x0300)
#define SQL_CA2_MAX_ROWS_SELECT         0x00000080L
#define SQL_CA2_MAX_ROWS_INSERT         0x00000100L
#define SQL_CA2_MAX_ROWS_DELETE         0x00000200L
#define SQL_CA2_MAX_ROWS_UPDATE         0x00000400L
#define SQL_CA2_MAX_ROWS_CATALOG        0x00000800L
#define SQL_CA2_MAX_ROWS_AFFECTS_ALL        (SQL_CA2_MAX_ROWS_SELECT | \
                         SQL_CA2_MAX_ROWS_INSERT | \
                         SQL_CA2_MAX_ROWS_DELETE | \
                         SQL_CA2_MAX_ROWS_UPDATE | \
                         SQL_CA2_MAX_ROWS_CATALOG)
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQL_DIAG_CURSOR_ROW_COUNT
 */
#if (ODBCVER >= 0x0300)
#define SQL_CA2_CRC_EXACT           0x00001000L
#define SQL_CA2_CRC_APPROXIMATE         0x00002000L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  the kinds of positioned statements that can be simulated
 */
#if (ODBCVER >= 0x0300)
#define SQL_CA2_SIMULATE_NON_UNIQUE     0x00004000L
#define SQL_CA2_SIMULATE_TRY_UNIQUE     0x00008000L
#define SQL_CA2_SIMULATE_UNIQUE         0x00010000L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_FETCH_DIRECTION
 */
#if (ODBCVER < 0x0300)
#define SQL_FD_FETCH_RESUME         0x00000040L
#endif  /* ODBCVER < 0x0300 */
#define SQL_FD_FETCH_BOOKMARK           0x00000080L


/*
 *  SQLGetInfo - SQL_FILE_USAGE
 */
#define SQL_FILE_NOT_SUPPORTED          0x0000
#define SQL_FILE_TABLE              0x0001
#define SQL_FILE_QUALIFIER          0x0002
#define SQL_FILE_CATALOG            SQL_FILE_QUALIFIER


/*
 *  SQLGetInfo - SQL_GETDATA_EXTENSIONS
 */
#define SQL_GD_BLOCK                0x00000004L
#define SQL_GD_BOUND                0x00000008L


/*
 *  SQLGetInfo - SQL_GROUP_BY
 */
#define SQL_GB_NOT_SUPPORTED            0x0000
#define SQL_GB_GROUP_BY_EQUALS_SELECT       0x0001
#define SQL_GB_GROUP_BY_CONTAINS_SELECT     0x0002
#define SQL_GB_NO_RELATION          0x0003
#if (ODBCVER >= 0x0300)
#define SQL_GB_COLLATE              0x0004
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_INDEX_KEYWORDS
 */
#if (ODBCVER >= 0x0300)
#define SQL_IK_NONE             0x00000000L
#define SQL_IK_ASC              0x00000001L
#define SQL_IK_DESC             0x00000002L
#define SQL_IK_ALL              (SQL_IK_ASC | SQL_IK_DESC)
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_INFO_SCHEMA_VIEWS
 */
#if (ODBCVER >= 0x0300)
#define SQL_ISV_ASSERTIONS          0x00000001L
#define SQL_ISV_CHARACTER_SETS          0x00000002L
#define SQL_ISV_CHECK_CONSTRAINTS       0x00000004L
#define SQL_ISV_COLLATIONS          0x00000008L
#define SQL_ISV_COLUMN_DOMAIN_USAGE     0x00000010L
#define SQL_ISV_COLUMN_PRIVILEGES       0x00000020L
#define SQL_ISV_COLUMNS             0x00000040L
#define SQL_ISV_CONSTRAINT_COLUMN_USAGE     0x00000080L
#define SQL_ISV_CONSTRAINT_TABLE_USAGE      0x00000100L
#define SQL_ISV_DOMAIN_CONSTRAINTS      0x00000200L
#define SQL_ISV_DOMAINS             0x00000400L
#define SQL_ISV_KEY_COLUMN_USAGE        0x00000800L
#define SQL_ISV_REFERENTIAL_CONSTRAINTS     0x00001000L
#define SQL_ISV_SCHEMATA            0x00002000L
#define SQL_ISV_SQL_LANGUAGES           0x00004000L
#define SQL_ISV_TABLE_CONSTRAINTS       0x00008000L
#define SQL_ISV_TABLE_PRIVILEGES        0x00010000L
#define SQL_ISV_TABLES              0x00020000L
#define SQL_ISV_TRANSLATIONS            0x00040000L
#define SQL_ISV_USAGE_PRIVILEGES        0x00080000L
#define SQL_ISV_VIEW_COLUMN_USAGE       0x00100000L
#define SQL_ISV_VIEW_TABLE_USAGE        0x00200000L
#define SQL_ISV_VIEWS               0x00400000L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_INSERT_STATEMENT
 */
#if (ODBCVER >= 0x0300)
#define SQL_IS_INSERT_LITERALS          0x00000001L
#define SQL_IS_INSERT_SEARCHED          0x00000002L
#define SQL_IS_SELECT_INTO          0x00000004L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_LOCK_TYPES
 */
#define SQL_LCK_NO_CHANGE           0x00000001L
#define SQL_LCK_EXCLUSIVE           0x00000002L
#define SQL_LCK_UNLOCK              0x00000004L


/*
 *  SQLGetInfo - SQL_POS_OPERATIONS
 */
#define SQL_POS_POSITION            0x00000001L
#define SQL_POS_REFRESH             0x00000002L
#define SQL_POS_UPDATE              0x00000004L
#define SQL_POS_DELETE              0x00000008L
#define SQL_POS_ADD             0x00000010L


/*
 *  SQLGetInfo - SQL_NON_NULLABLE_COLUMNS
 */
#define SQL_NNC_NULL                0x0000
#define SQL_NNC_NON_NULL            0x0001


/*
 *  SQLGetInfo - SQL_NULL_COLLATION
 */
#define SQL_NC_START                0x0002
#define SQL_NC_END              0x0004


/*
 *  SQLGetInfo - SQL_NUMERIC_FUNCTIONS
 */
#define SQL_FN_NUM_ABS              0x00000001L
#define SQL_FN_NUM_ACOS             0x00000002L
#define SQL_FN_NUM_ASIN             0x00000004L
#define SQL_FN_NUM_ATAN             0x00000008L
#define SQL_FN_NUM_ATAN2            0x00000010L
#define SQL_FN_NUM_CEILING          0x00000020L
#define SQL_FN_NUM_COS              0x00000040L
#define SQL_FN_NUM_COT              0x00000080L
#define SQL_FN_NUM_EXP              0x00000100L
#define SQL_FN_NUM_FLOOR            0x00000200L
#define SQL_FN_NUM_LOG              0x00000400L
#define SQL_FN_NUM_MOD              0x00000800L
#define SQL_FN_NUM_SIGN             0x00001000L
#define SQL_FN_NUM_SIN              0x00002000L
#define SQL_FN_NUM_SQRT             0x00004000L
#define SQL_FN_NUM_TAN              0x00008000L
#define SQL_FN_NUM_PI               0x00010000L
#define SQL_FN_NUM_RAND             0x00020000L
#define SQL_FN_NUM_DEGREES          0x00040000L
#define SQL_FN_NUM_LOG10            0x00080000L
#define SQL_FN_NUM_POWER            0x00100000L
#define SQL_FN_NUM_RADIANS          0x00200000L
#define SQL_FN_NUM_ROUND            0x00400000L
#define SQL_FN_NUM_TRUNCATE         0x00800000L


/*
 *  SQLGetInfo - SQL_ODBC_API_CONFORMANCE
 */
#define SQL_OAC_NONE                0x0000
#define SQL_OAC_LEVEL1              0x0001
#define SQL_OAC_LEVEL2              0x0002


/*
 *  SQLGetInfo - SQL_ODBC_INTERFACE_CONFORMANCE
 */
#if (ODBCVER >= 0x0300)
#define SQL_OIC_CORE                1UL
#define SQL_OIC_LEVEL1              2UL
#define SQL_OIC_LEVEL2              3UL
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_ODBC_SAG_CLI_CONFORMANCE
 */
#define SQL_OSCC_NOT_COMPLIANT          0x0000
#define SQL_OSCC_COMPLIANT          0x0001


/*
 *  SQLGetInfo - SQL_ODBC_SQL_CONFORMANCE
 */
#define SQL_OSC_MINIMUM             0x0000
#define SQL_OSC_CORE                0x0001
#define SQL_OSC_EXTENDED            0x0002


/*
 *  SQLGetInfo - SQL_OWNER_USAGE
 */
#define SQL_OU_DML_STATEMENTS           0x00000001L
#define SQL_OU_PROCEDURE_INVOCATION     0x00000002L
#define SQL_OU_TABLE_DEFINITION         0x00000004L
#define SQL_OU_INDEX_DEFINITION         0x00000008L
#define SQL_OU_PRIVILEGE_DEFINITION     0x00000010L


/*
 *  SQLGetInfo - SQL_PARAM_ARRAY_ROW_COUNTS
 */
#if (ODBCVER >= 0x0300)
#define SQL_PARC_BATCH              1
#define SQL_PARC_NO_BATCH           2
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_PARAM_ARRAY_SELECTS
 */
#if (ODBCVER >= 0x0300)
#define SQL_PAS_BATCH               1
#define SQL_PAS_NO_BATCH            2
#define SQL_PAS_NO_SELECT           3
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_POSITIONED_STATEMENTS
 */
#define SQL_PS_POSITIONED_DELETE        0x00000001L
#define SQL_PS_POSITIONED_UPDATE        0x00000002L
#define SQL_PS_SELECT_FOR_UPDATE        0x00000004L


/*
 *  SQLGetInfo - SQL_QUALIFIER_LOCATION
 */
#define SQL_QL_START                0x0001
#define SQL_QL_END              0x0002


/*
 *  SQLGetInfo - SQL_QUALIFIER_USAGE
 */
#define SQL_QU_DML_STATEMENTS           0x00000001L
#define SQL_QU_PROCEDURE_INVOCATION     0x00000002L
#define SQL_QU_TABLE_DEFINITION         0x00000004L
#define SQL_QU_INDEX_DEFINITION         0x00000008L
#define SQL_QU_PRIVILEGE_DEFINITION     0x00000010L


/*
 *  SQLGetInfo - SQL_SCHEMA_USAGE
 */
#if (ODBCVER >= 0x0300)
#define SQL_SU_DML_STATEMENTS           SQL_OU_DML_STATEMENTS
#define SQL_SU_PROCEDURE_INVOCATION     SQL_OU_PROCEDURE_INVOCATION
#define SQL_SU_TABLE_DEFINITION         SQL_OU_TABLE_DEFINITION
#define SQL_SU_INDEX_DEFINITION         SQL_OU_INDEX_DEFINITION
#define SQL_SU_PRIVILEGE_DEFINITION     SQL_OU_PRIVILEGE_DEFINITION
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_SCROLL_OPTIONS
 */
#define SQL_SO_FORWARD_ONLY         0x00000001L
#define SQL_SO_KEYSET_DRIVEN            0x00000002L
#define SQL_SO_DYNAMIC              0x00000004L
#define SQL_SO_MIXED                0x00000008L
#define SQL_SO_STATIC               0x00000010L


/*
 *  SQLGetInfo - SQL_SQL_CONFORMANCE
 */
#if (ODBCVER >= 0x0300)
#define SQL_SC_SQL92_ENTRY          0x00000001L
#define SQL_SC_FIPS127_2_TRANSITIONAL       0x00000002L
#define SQL_SC_SQL92_INTERMEDIATE       0x00000004L
#define SQL_SC_SQL92_FULL           0x00000008L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_SQL92_DATETIME_FUNCTIONS
 */
#if (ODBCVER >= 0x0300)
#define SQL_SDF_CURRENT_DATE            0x00000001L
#define SQL_SDF_CURRENT_TIME            0x00000002L
#define SQL_SDF_CURRENT_TIMESTAMP       0x00000004L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_SQL92_FOREIGN_KEY_DELETE_RULE
 */
#if (ODBCVER >= 0x0300)
#define SQL_SFKD_CASCADE            0x00000001L
#define SQL_SFKD_NO_ACTION          0x00000002L
#define SQL_SFKD_SET_DEFAULT            0x00000004L
#define SQL_SFKD_SET_NULL           0x00000008L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_SQL92_FOREIGN_KEY_UPDATE_RULE
 */
#if (ODBCVER >= 0x0300)
#define SQL_SFKU_CASCADE            0x00000001L
#define SQL_SFKU_NO_ACTION          0x00000002L
#define SQL_SFKU_SET_DEFAULT            0x00000004L
#define SQL_SFKU_SET_NULL           0x00000008L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_SQL92_GRANT
 */
#if (ODBCVER >= 0x0300)
#define SQL_SG_USAGE_ON_DOMAIN          0x00000001L
#define SQL_SG_USAGE_ON_CHARACTER_SET       0x00000002L
#define SQL_SG_USAGE_ON_COLLATION       0x00000004L
#define SQL_SG_USAGE_ON_TRANSLATION     0x00000008L
#define SQL_SG_WITH_GRANT_OPTION        0x00000010L
#define SQL_SG_DELETE_TABLE         0x00000020L
#define SQL_SG_INSERT_TABLE         0x00000040L
#define SQL_SG_INSERT_COLUMN            0x00000080L
#define SQL_SG_REFERENCES_TABLE         0x00000100L
#define SQL_SG_REFERENCES_COLUMN        0x00000200L
#define SQL_SG_SELECT_TABLE         0x00000400L
#define SQL_SG_UPDATE_TABLE         0x00000800L
#define SQL_SG_UPDATE_COLUMN            0x00001000L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_SQL92_NUMERIC_VALUE_FUNCTIONS
 */
#if (ODBCVER >= 0x0300)
#define SQL_SNVF_BIT_LENGTH         0x00000001L
#define SQL_SNVF_CHAR_LENGTH            0x00000002L
#define SQL_SNVF_CHARACTER_LENGTH       0x00000004L
#define SQL_SNVF_EXTRACT            0x00000008L
#define SQL_SNVF_OCTET_LENGTH           0x00000010L
#define SQL_SNVF_POSITION           0x00000020L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_SQL92_PREDICATES
 */
#if (ODBCVER >= 0x0300)
#define SQL_SP_EXISTS               0x00000001L
#define SQL_SP_ISNOTNULL            0x00000002L
#define SQL_SP_ISNULL               0x00000004L
#define SQL_SP_MATCH_FULL           0x00000008L
#define SQL_SP_MATCH_PARTIAL            0x00000010L
#define SQL_SP_MATCH_UNIQUE_FULL        0x00000020L
#define SQL_SP_MATCH_UNIQUE_PARTIAL     0x00000040L
#define SQL_SP_OVERLAPS             0x00000080L
#define SQL_SP_UNIQUE               0x00000100L
#define SQL_SP_LIKE             0x00000200L
#define SQL_SP_IN               0x00000400L
#define SQL_SP_BETWEEN              0x00000800L
#define SQL_SP_COMPARISON           0x00001000L
#define SQL_SP_QUANTIFIED_COMPARISON        0x00002000L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_SQL92_RELATIONAL_JOIN_OPERATORS
 */
#if (ODBCVER >= 0x0300)
#define SQL_SRJO_CORRESPONDING_CLAUSE       0x00000001L
#define SQL_SRJO_CROSS_JOIN         0x00000002L
#define SQL_SRJO_EXCEPT_JOIN            0x00000004L
#define SQL_SRJO_FULL_OUTER_JOIN        0x00000008L
#define SQL_SRJO_INNER_JOIN         0x00000010L
#define SQL_SRJO_INTERSECT_JOIN         0x00000020L
#define SQL_SRJO_LEFT_OUTER_JOIN        0x00000040L
#define SQL_SRJO_NATURAL_JOIN           0x00000080L
#define SQL_SRJO_RIGHT_OUTER_JOIN       0x00000100L
#define SQL_SRJO_UNION_JOIN         0x00000200L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_SQL92_REVOKE
 */
#if (ODBCVER >= 0x0300)
#define SQL_SR_USAGE_ON_DOMAIN          0x00000001L
#define SQL_SR_USAGE_ON_CHARACTER_SET       0x00000002L
#define SQL_SR_USAGE_ON_COLLATION       0x00000004L
#define SQL_SR_USAGE_ON_TRANSLATION     0x00000008L
#define SQL_SR_GRANT_OPTION_FOR         0x00000010L
#define SQL_SR_CASCADE              0x00000020L
#define SQL_SR_RESTRICT             0x00000040L
#define SQL_SR_DELETE_TABLE         0x00000080L
#define SQL_SR_INSERT_TABLE         0x00000100L
#define SQL_SR_INSERT_COLUMN            0x00000200L
#define SQL_SR_REFERENCES_TABLE         0x00000400L
#define SQL_SR_REFERENCES_COLUMN        0x00000800L
#define SQL_SR_SELECT_TABLE         0x00001000L
#define SQL_SR_UPDATE_TABLE         0x00002000L
#define SQL_SR_UPDATE_COLUMN            0x00004000L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_SQL92_ROW_VALUE_CONSTRUCTOR
 */
#if (ODBCVER >= 0x0300)
#define SQL_SRVC_VALUE_EXPRESSION       0x00000001L
#define SQL_SRVC_NULL               0x00000002L
#define SQL_SRVC_DEFAULT            0x00000004L
#define SQL_SRVC_ROW_SUBQUERY           0x00000008L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_SQL92_STRING_FUNCTIONS
 */
#if (ODBCVER >= 0x0300)
#define SQL_SSF_CONVERT             0x00000001L
#define SQL_SSF_LOWER               0x00000002L
#define SQL_SSF_UPPER               0x00000004L
#define SQL_SSF_SUBSTRING           0x00000008L
#define SQL_SSF_TRANSLATE           0x00000010L
#define SQL_SSF_TRIM_BOTH           0x00000020L
#define SQL_SSF_TRIM_LEADING            0x00000040L
#define SQL_SSF_TRIM_TRAILING           0x00000080L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_SQL92_VALUE_EXPRESSIONS
 */
#if (ODBCVER >= 0x0300)
#define SQL_SVE_CASE                0x00000001L
#define SQL_SVE_CAST                0x00000002L
#define SQL_SVE_COALESCE            0x00000004L
#define SQL_SVE_NULLIF              0x00000008L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_STANDARD_CLI_CONFORMANCE
 */
#if (ODBCVER >= 0x0300)
#define SQL_SCC_XOPEN_CLI_VERSION1      0x00000001L
#define SQL_SCC_ISO92_CLI           0x00000002L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_STATIC_SENSITIVITY
 */
#define SQL_SS_ADDITIONS            0x00000001L
#define SQL_SS_DELETIONS            0x00000002L
#define SQL_SS_UPDATES              0x00000004L


/*
 *  SQLGetInfo - SQL_SUBQUERIES
 */
#define SQL_SQ_COMPARISON           0x00000001L
#define SQL_SQ_EXISTS               0x00000002L
#define SQL_SQ_IN               0x00000004L
#define SQL_SQ_QUANTIFIED           0x00000008L
#define SQL_SQ_CORRELATED_SUBQUERIES        0x00000010L


/*
 *  SQLGetInfo - SQL_SYSTEM_FUNCTIONS
 */
#define SQL_FN_SYS_USERNAME         0x00000001L
#define SQL_FN_SYS_DBNAME           0x00000002L
#define SQL_FN_SYS_IFNULL           0x00000004L


/*
 *  SQLGetInfo - SQL_STRING_FUNCTIONS
 */
#define SQL_FN_STR_CONCAT           0x00000001L
#define SQL_FN_STR_INSERT           0x00000002L
#define SQL_FN_STR_LEFT             0x00000004L
#define SQL_FN_STR_LTRIM            0x00000008L
#define SQL_FN_STR_LENGTH           0x00000010L
#define SQL_FN_STR_LOCATE           0x00000020L
#define SQL_FN_STR_LCASE            0x00000040L
#define SQL_FN_STR_REPEAT           0x00000080L
#define SQL_FN_STR_REPLACE          0x00000100L
#define SQL_FN_STR_RIGHT            0x00000200L
#define SQL_FN_STR_RTRIM            0x00000400L
#define SQL_FN_STR_SUBSTRING            0x00000800L
#define SQL_FN_STR_UCASE            0x00001000L
#define SQL_FN_STR_ASCII            0x00002000L
#define SQL_FN_STR_CHAR             0x00004000L
#define SQL_FN_STR_DIFFERENCE           0x00008000L
#define SQL_FN_STR_LOCATE_2         0x00010000L
#define SQL_FN_STR_SOUNDEX          0x00020000L
#define SQL_FN_STR_SPACE            0x00040000L
#if (ODBCVER >= 0x0300)
#define SQL_FN_STR_BIT_LENGTH           0x00080000L
#define SQL_FN_STR_CHAR_LENGTH          0x00100000L
#define SQL_FN_STR_CHARACTER_LENGTH     0x00200000L
#define SQL_FN_STR_OCTET_LENGTH         0x00400000L
#define SQL_FN_STR_POSITION         0x00800000L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_TIMEDATE_ADD_INTERVALS
 *  SQLGetInfo - SQL_TIMEDATE_DIFF_INTERVALS
 */
#define SQL_FN_TSI_FRAC_SECOND          0x00000001L
#define SQL_FN_TSI_SECOND           0x00000002L
#define SQL_FN_TSI_MINUTE           0x00000004L
#define SQL_FN_TSI_HOUR             0x00000008L
#define SQL_FN_TSI_DAY              0x00000010L
#define SQL_FN_TSI_WEEK             0x00000020L
#define SQL_FN_TSI_MONTH            0x00000040L
#define SQL_FN_TSI_QUARTER          0x00000080L
#define SQL_FN_TSI_YEAR             0x00000100L


/*
 *  SQLGetInfo - SQL_TIMEDATE_FUNCTIONS
 */
#define SQL_FN_TD_NOW               0x00000001L
#define SQL_FN_TD_CURDATE           0x00000002L
#define SQL_FN_TD_DAYOFMONTH            0x00000004L
#define SQL_FN_TD_DAYOFWEEK         0x00000008L
#define SQL_FN_TD_DAYOFYEAR         0x00000010L
#define SQL_FN_TD_MONTH             0x00000020L
#define SQL_FN_TD_QUARTER           0x00000040L
#define SQL_FN_TD_WEEK              0x00000080L
#define SQL_FN_TD_YEAR              0x00000100L
#define SQL_FN_TD_CURTIME           0x00000200L
#define SQL_FN_TD_HOUR              0x00000400L
#define SQL_FN_TD_MINUTE            0x00000800L
#define SQL_FN_TD_SECOND            0x00001000L
#define SQL_FN_TD_TIMESTAMPADD          0x00002000L
#define SQL_FN_TD_TIMESTAMPDIFF         0x00004000L
#define SQL_FN_TD_DAYNAME           0x00008000L
#define SQL_FN_TD_MONTHNAME         0x00010000L
#if (ODBCVER >= 0x0300)
#define SQL_FN_TD_CURRENT_DATE          0x00020000L
#define SQL_FN_TD_CURRENT_TIME          0x00040000L
#define SQL_FN_TD_CURRENT_TIMESTAMP     0x00080000L
#define SQL_FN_TD_EXTRACT           0x00100000L
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetInfo - SQL_TXN_ISOLATION_OPTION
 */
#if (ODBCVER < 0x0300)
#define SQL_TXN_VERSIONING          0x00000010L
#endif  /* ODBCVER < 0x0300 */


/*
 *  SQLGetInfo - SQL_UNION
 */
#define SQL_U_UNION             0x00000001L
#define SQL_U_UNION_ALL             0x00000002L


/*
 *  SQLGetInfo - SQL_UNION_STATEMENT
 */
#if (ODBCVER >= 0x0300)
#define SQL_US_UNION                SQL_U_UNION
#define SQL_US_UNION_ALL            SQL_U_UNION_ALL
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetStmtAttr - ODBC 2.x attributes
 */
#define SQL_QUERY_TIMEOUT           0
#define SQL_MAX_ROWS                1
#define SQL_NOSCAN              2
#define SQL_MAX_LENGTH              3
#define SQL_ASYNC_ENABLE            4
#define SQL_BIND_TYPE               5
#define SQL_CURSOR_TYPE             6
#define SQL_CONCURRENCY             7
#define SQL_KEYSET_SIZE             8
#define SQL_ROWSET_SIZE             9
#define SQL_SIMULATE_CURSOR         10
#define SQL_RETRIEVE_DATA           11
#define SQL_USE_BOOKMARKS           12
#define SQL_GET_BOOKMARK            13
#define SQL_ROW_NUMBER              14


/*
 *  SQLGetStmtAttr - ODBC 3.x attributes
 */
#if (ODBCVER >= 0x0300)
#define SQL_ATTR_ASYNC_ENABLE           4
#define SQL_ATTR_CONCURRENCY            SQL_CONCURRENCY
#define SQL_ATTR_CURSOR_TYPE            SQL_CURSOR_TYPE
#define SQL_ATTR_ENABLE_AUTO_IPD        15
#define SQL_ATTR_FETCH_BOOKMARK_PTR     16
#define SQL_ATTR_KEYSET_SIZE            SQL_KEYSET_SIZE
#define SQL_ATTR_MAX_LENGTH         SQL_MAX_LENGTH
#define SQL_ATTR_MAX_ROWS           SQL_MAX_ROWS
#define SQL_ATTR_NOSCAN             SQL_NOSCAN
#define SQL_ATTR_PARAM_BIND_OFFSET_PTR      17
#define SQL_ATTR_PARAM_BIND_TYPE        18
#define SQL_ATTR_PARAM_OPERATION_PTR        19
#define SQL_ATTR_PARAM_STATUS_PTR       20
#define SQL_ATTR_PARAMS_PROCESSED_PTR       21
#define SQL_ATTR_PARAMSET_SIZE          22
#define SQL_ATTR_QUERY_TIMEOUT          SQL_QUERY_TIMEOUT
#define SQL_ATTR_RETRIEVE_DATA          SQL_RETRIEVE_DATA
#define SQL_ATTR_ROW_BIND_OFFSET_PTR        23
#define SQL_ATTR_ROW_BIND_TYPE          SQL_BIND_TYPE
#define SQL_ATTR_ROW_NUMBER         SQL_ROW_NUMBER  /*GetStmtAttr*/
#define SQL_ATTR_ROW_OPERATION_PTR      24
#define SQL_ATTR_ROW_STATUS_PTR         25
#define SQL_ATTR_ROWS_FETCHED_PTR       26
#define SQL_ATTR_ROW_ARRAY_SIZE         27
#define SQL_ATTR_SIMULATE_CURSOR        SQL_SIMULATE_CURSOR
#define SQL_ATTR_USE_BOOKMARKS          SQL_USE_BOOKMARKS
#endif  /* ODBCVER >= 0x0300 */

#if (ODBCVER < 0x0300)
#define SQL_STMT_OPT_MAX            SQL_ROW_NUMBER
#define SQL_STMT_OPT_MIN            SQL_QUERY_TIMEOUT
#endif  /* ODBCVER < 0x0300 */


/*
 *  SQLGetStmtAttr - SQL_ATTR_ASYNC_ENABLE
 */
#define SQL_ASYNC_ENABLE_OFF            0UL
#define SQL_ASYNC_ENABLE_ON         1UL
#define SQL_ASYNC_ENABLE_DEFAULT        SQL_ASYNC_ENABLE_OFF


/*
 *  SQLGetStmtAttr -  SQL_ATTR_PARAM_BIND_TYPE
 */
#if (ODBCVER >= 0x0300)
#define SQL_PARAM_BIND_BY_COLUMN        0UL
#define SQL_PARAM_BIND_TYPE_DEFAULT     SQL_PARAM_BIND_BY_COLUMN
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetStmtAttr - SQL_BIND_TYPE
 */
#define SQL_BIND_BY_COLUMN          0UL
#define SQL_BIND_TYPE_DEFAULT           SQL_BIND_BY_COLUMN


/*
 *  SQLGetStmtAttr - SQL_CONCURRENCY
 */
#define SQL_CONCUR_READ_ONLY            1
#define SQL_CONCUR_LOCK             2
#define SQL_CONCUR_ROWVER           3
#define SQL_CONCUR_VALUES           4
#define SQL_CONCUR_DEFAULT          SQL_CONCUR_READ_ONLY


/*
 *  SQLGetStmtAttr - SQL_CURSOR_TYPE
 */
#define SQL_CURSOR_FORWARD_ONLY         0UL
#define SQL_CURSOR_KEYSET_DRIVEN        1UL
#define SQL_CURSOR_DYNAMIC          2UL
#define SQL_CURSOR_STATIC           3UL
#define SQL_CURSOR_TYPE_DEFAULT         SQL_CURSOR_FORWARD_ONLY


/*
 *  SQLGetStmtAttr - SQL_KEYSET_SIZE
 */
#define SQL_KEYSET_SIZE_DEFAULT         0UL


/*
 *  SQLGetStmtAttr - SQL_MAX_LENGTH
 */
#define SQL_MAX_LENGTH_DEFAULT          0UL


/*
 *  SQLGetStmtAttr - SQL_MAX_ROWS
 */
#define SQL_MAX_ROWS_DEFAULT            0UL


/*
 *  SQLGetStmtAttr - SQL_NOSCAN
 */
#define SQL_NOSCAN_OFF              0UL /* 1.0 FALSE */
#define SQL_NOSCAN_ON               1UL /* 1.0 TRUE */
#define SQL_NOSCAN_DEFAULT          SQL_NOSCAN_OFF


/*
 *  SQLGetStmtAttr - SQL_QUERY_TIMEOUT
 */
#define SQL_QUERY_TIMEOUT_DEFAULT       0UL


/*
 *  SQLGetStmtAttr - SQL_RETRIEVE_DATA
 */
#define SQL_RD_OFF              0UL
#define SQL_RD_ON               1UL
#define SQL_RD_DEFAULT              SQL_RD_ON


/*
 *  SQLGetStmtAttr - SQL_ROWSET_SIZE
 */
#define SQL_ROWSET_SIZE_DEFAULT         1UL


/*
 *  SQLGetStmtAttr - SQL_SIMULATE_CURSOR
 */
#define SQL_SC_NON_UNIQUE           0UL
#define SQL_SC_TRY_UNIQUE           1UL
#define SQL_SC_UNIQUE               2UL


/*
 *  SQLGetStmtAttr - SQL_USE_BOOKMARKS
 */
#define SQL_UB_OFF              0UL
#define SQL_UB_ON               1UL
#define SQL_UB_DEFAULT              SQL_UB_OFF
#if (ODBCVER >= 0x0300)
#define SQL_UB_FIXED                SQL_UB_ON
#define SQL_UB_VARIABLE             2UL
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLGetTypeInfo - SEARCHABLE
 */
#if (ODBCVER >= 0x0300)
#define SQL_COL_PRED_CHAR           SQL_LIKE_ONLY
#define SQL_COL_PRED_BASIC          SQL_ALL_EXCEPT_LIKE
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLSetPos
 */
#define SQL_ENTIRE_ROWSET           0


/*
 *  SQLSetPos - Operation
 */
#define SQL_POSITION                0
#define SQL_REFRESH             1
#define SQL_UPDATE              2
#define SQL_DELETE              3


/*
 *  SQLBulkOperations - Operation
 */
#define SQL_ADD                 4
#define SQL_SETPOS_MAX_OPTION_VALUE     SQL_ADD
#if (ODBCVER >= 0x0300)
#define SQL_UPDATE_BY_BOOKMARK          5
#define SQL_DELETE_BY_BOOKMARK          6
#define SQL_FETCH_BY_BOOKMARK           7
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLSetPos - LockType
 */
#define SQL_LOCK_NO_CHANGE          0
#define SQL_LOCK_EXCLUSIVE          1
#define SQL_LOCK_UNLOCK             2
#define SQL_SETPOS_MAX_LOCK_VALUE       SQL_LOCK_UNLOCK


/*
 *  SQLSetPos macros
 */
#define SQL_POSITION_TO(hstmt,irow) \
    SQLSetPos(hstmt,irow,SQL_POSITION,SQL_LOCK_NO_CHANGE)
#define SQL_LOCK_RECORD(hstmt,irow,fLock) \
    SQLSetPos(hstmt,irow,SQL_POSITION,fLock)
#define SQL_REFRESH_RECORD(hstmt,irow,fLock) \
    SQLSetPos(hstmt,irow,SQL_REFRESH,fLock)
#define SQL_UPDATE_RECORD(hstmt,irow) \
    SQLSetPos(hstmt,irow,SQL_UPDATE,SQL_LOCK_NO_CHANGE)
#define SQL_DELETE_RECORD(hstmt,irow) \
    SQLSetPos(hstmt,irow,SQL_DELETE,SQL_LOCK_NO_CHANGE)
#define SQL_ADD_RECORD(hstmt,irow) \
    SQLSetPos(hstmt,irow,SQL_ADD,SQL_LOCK_NO_CHANGE)


/*
 *  SQLSpecialColumns - Column types and scopes
 */
#define SQL_BEST_ROWID              1
#define SQL_ROWVER              2


/*
 *  All the ODBC keywords
 */
#define SQL_ODBC_KEYWORDS \
"ABSOLUTE,ACTION,ADA,ADD,ALL,ALLOCATE,ALTER,AND,ANY,ARE,AS,"\
"ASC,ASSERTION,AT,AUTHORIZATION,AVG,"\
"BEGIN,BETWEEN,BIT,BIT_LENGTH,BOTH,BY,CASCADE,CASCADED,CASE,CAST,CATALOG,"\
"CHAR,CHAR_LENGTH,CHARACTER,CHARACTER_LENGTH,CHECK,CLOSE,COALESCE,"\
"COLLATE,COLLATION,COLUMN,COMMIT,CONNECT,CONNECTION,CONSTRAINT,"\
"CONSTRAINTS,CONTINUE,CONVERT,CORRESPONDING,COUNT,CREATE,CROSS,CURRENT,"\
"CURRENT_DATE,CURRENT_TIME,CURRENT_TIMESTAMP,CURRENT_USER,CURSOR,"\
"DATE,DAY,DEALLOCATE,DEC,DECIMAL,DECLARE,DEFAULT,DEFERRABLE,"\
"DEFERRED,DELETE,DESC,DESCRIBE,DESCRIPTOR,DIAGNOSTICS,DISCONNECT,"\
"DISTINCT,DOMAIN,DOUBLE,DROP,"\
"ELSE,END,END-EXEC,ESCAPE,EXCEPT,EXCEPTION,EXEC,EXECUTE,"\
"EXISTS,EXTERNAL,EXTRACT,"\
"FALSE,FETCH,FIRST,FLOAT,FOR,FOREIGN,FORTRAN,FOUND,FROM,FULL,"\
"GET,GLOBAL,GO,GOTO,GRANT,GROUP,HAVING,HOUR,"\
"IDENTITY,IMMEDIATE,IN,INCLUDE,INDEX,INDICATOR,INITIALLY,INNER,"\
"INPUT,INSENSITIVE,INSERT,INT,INTEGER,INTERSECT,INTERVAL,INTO,IS,ISOLATION,"\
"JOIN,KEY,LANGUAGE,LAST,LEADING,LEFT,LEVEL,LIKE,LOCAL,LOWER,"\
"MATCH,MAX,MIN,MINUTE,MODULE,MONTH,"\
"NAMES,NATIONAL,NATURAL,NCHAR,NEXT,NO,NONE,NOT,NULL,NULLIF,NUMERIC,"\
"OCTET_LENGTH,OF,ON,ONLY,OPEN,OPTION,OR,ORDER,OUTER,OUTPUT,OVERLAPS,"\
"PAD,PARTIAL,PASCAL,PLI,POSITION,PRECISION,PREPARE,PRESERVE,"\
"PRIMARY,PRIOR,PRIVILEGES,PROCEDURE,PUBLIC,"\
"READ,REAL,REFERENCES,RELATIVE,RESTRICT,REVOKE,RIGHT,ROLLBACK,ROWS"\
"SCHEMA,SCROLL,SECOND,SECTION,SELECT,SESSION,SESSION_USER,SET,SIZE,"\
"SMALLINT,SOME,SPACE,SQL,SQLCA,SQLCODE,SQLERROR,SQLSTATE,SQLWARNING,"\
"SUBSTRING,SUM,SYSTEM_USER,"\
"TABLE,TEMPORARY,THEN,TIME,TIMESTAMP,TIMEZONE_HOUR,TIMEZONE_MINUTE,"\
"TO,TRAILING,TRANSACTION,TRANSLATE,TRANSLATION,TRIM,TRUE,"\
"UNION,UNIQUE,UNKNOWN,UPDATE,UPPER,USAGE,USER,USING,"\
"VALUE,VALUES,VARCHAR,VARYING,VIEW,WHEN,WHENEVER,WHERE,WITH,WORK,WRITE,"\
"YEAR,ZONE"


/*
 * ----------------------------------------------------------------------
 *  Level 2 Functions
 * ----------------------------------------------------------------------
 */

/*
 *  SQLExtendedFetch - fFetchType
 */
#define SQL_FETCH_BOOKMARK          8


/*
 *  SQLExtendedFetch - rgfRowStatus
 */
#define SQL_ROW_SUCCESS             0
#define SQL_ROW_DELETED             1
#define SQL_ROW_UPDATED             2
#define SQL_ROW_NOROW               3
#define SQL_ROW_ADDED               4
#define SQL_ROW_ERROR               5
#if (ODBCVER >= 0x0300)
#define SQL_ROW_SUCCESS_WITH_INFO       6
#define SQL_ROW_PROCEED             0
#define SQL_ROW_IGNORE              1
#endif


/*
 * SQL_DESC_ARRAY_STATUS_PTR
 */
#if (ODBCVER >= 0x0300)
#define SQL_PARAM_SUCCESS           0
#define SQL_PARAM_SUCCESS_WITH_INFO     6
#define SQL_PARAM_ERROR             5
#define SQL_PARAM_UNUSED            7
#define SQL_PARAM_DIAG_UNAVAILABLE      1

#define SQL_PARAM_PROCEED           0
#define SQL_PARAM_IGNORE            1
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLForeignKeys - UPDATE_RULE/DELETE_RULE
 */
#define SQL_CASCADE             0
#define SQL_RESTRICT                1
#define SQL_SET_NULL                2

#if (ODBCVER >= 0x0250)
#define SQL_NO_ACTION               3
#define SQL_SET_DEFAULT             4
#endif  /* ODBCVER >= 0x0250 */


/*
 *  SQLForeignKeys - DEFERABILITY
 */
#if (ODBCVER >= 0x0300)
#define SQL_INITIALLY_DEFERRED          5
#define SQL_INITIALLY_IMMEDIATE         6
#define SQL_NOT_DEFERRABLE          7
#endif  /* ODBCVER >= 0x0300 */


/*
 *  SQLBindParameter - fParamType
 *  SQLProcedureColumns - COLUMN_TYPE
 */
#define SQL_PARAM_TYPE_UNKNOWN          0
#define SQL_PARAM_INPUT             1
#define SQL_PARAM_INPUT_OUTPUT          2
#define SQL_RESULT_COL              3
#define SQL_PARAM_OUTPUT            4
#define SQL_RETURN_VALUE            5


/*
 *   SQLProcedures - PROCEDURE_TYPE
 */
#define SQL_PT_UNKNOWN              0
#define SQL_PT_PROCEDURE            1
#define SQL_PT_FUNCTION             2


/*
 *  SQLSetParam to SQLBindParameter conversion
 */
#define SQL_PARAM_TYPE_DEFAULT          SQL_PARAM_INPUT_OUTPUT
#define SQL_SETPARAM_VALUE_MAX          (-1L)


/*
 *  SQLStatistics - fAccuracy
 */
#define SQL_QUICK               0
#define SQL_ENSURE              1


/*
 *  SQLStatistics - TYPE
 */
#define SQL_TABLE_STAT              0


/*
 *  SQLTables
 */
#if (ODBCVER >= 0x0300)
#define SQL_ALL_CATALOGS            "%"
#define SQL_ALL_SCHEMAS             "%"
#define SQL_ALL_TABLE_TYPES         "%"
#endif  /* ODBCVER >= 0x0300 */

/*
 *  SQLSpecialColumns - PSEUDO_COLUMN
 */
#define SQL_PC_NOT_PSEUDO           1


/*
 *  Deprecated defines from prior versions of ODBC
 */
#define SQL_DATABASE_NAME           16
#define SQL_FD_FETCH_PREV           SQL_FD_FETCH_PRIOR
#define SQL_FETCH_PREV              SQL_FETCH_PRIOR
#define SQL_CONCUR_TIMESTAMP            SQL_CONCUR_ROWVER
#define SQL_SCCO_OPT_TIMESTAMP          SQL_SCCO_OPT_ROWVER
#define SQL_CC_DELETE               SQL_CB_DELETE
#define SQL_CR_DELETE               SQL_CB_DELETE
#define SQL_CC_CLOSE                SQL_CB_CLOSE
#define SQL_CR_CLOSE                SQL_CB_CLOSE
#define SQL_CC_PRESERVE             SQL_CB_PRESERVE
#define SQL_CR_PRESERVE             SQL_CB_PRESERVE
#if (ODBCVER < 0x0200)
#define SQL_FETCH_RESUME            7
#endif
#define SQL_SCROLL_FORWARD_ONLY         0L
#define SQL_SCROLL_KEYSET_DRIVEN        (-1L)
#define SQL_SCROLL_DYNAMIC          (-2L)
#define SQL_SCROLL_STATIC           (-3L)


/*
 *  Level 1 function prototypes
 */
SQLRETURN SQL_API SQLDriverConnect (
    SQLHDBC       hdbc,
    SQLHWND       hwnd,
    SQLCHAR     * szConnStrIn,
    SQLSMALLINT       cbConnStrIn,
    SQLCHAR     * szConnStrOut,
    SQLSMALLINT       cbConnStrOutMax,
    SQLSMALLINT     * pcbConnStrOut,
    SQLUSMALLINT      fDriverCompletion);

/*
 *  Level 2 function prototypes
 */

SQLRETURN SQL_API SQLBrowseConnect (
    SQLHDBC       hdbc,
    SQLCHAR     * szConnStrIn,
    SQLSMALLINT       cbConnStrIn,
    SQLCHAR     * szConnStrOut,
    SQLSMALLINT       cbConnStrOutMax,
    SQLSMALLINT     * pcbConnStrOut);

#if (ODBCVER >= 0x0300)
SQLRETURN SQL_API SQLBulkOperations (
    SQLHSTMT          StatementHandle,
    SQLSMALLINT       Operation);
#endif /* ODBCVER >= 0x0300 */

SQLRETURN SQL_API SQLColAttributes (
    SQLHSTMT          hstmt,
    SQLUSMALLINT      icol,
    SQLUSMALLINT      fDescType,
    SQLPOINTER        rgbDesc,
    SQLSMALLINT       cbDescMax,
    SQLSMALLINT     * pcbDesc,
    SQLLEN      * pfDesc);

SQLRETURN SQL_API SQLColumnPrivileges (
    SQLHSTMT          hstmt,
    SQLCHAR     * szCatalogName,
    SQLSMALLINT       cbCatalogName,
    SQLCHAR     * szSchemaName,
    SQLSMALLINT       cbSchemaName,
    SQLCHAR     * szTableName,
    SQLSMALLINT       cbTableName,
    SQLCHAR     * szColumnName,
    SQLSMALLINT       cbColumnName);

SQLRETURN SQL_API SQLDescribeParam (
    SQLHSTMT          hstmt,
    SQLUSMALLINT      ipar,
    SQLSMALLINT     * pfSqlType,
    SQLULEN     * pcbParamDef,
    SQLSMALLINT     * pibScale,
    SQLSMALLINT     * pfNullable);

SQLRETURN SQL_API SQLExtendedFetch (
    SQLHSTMT          hstmt,
    SQLUSMALLINT      fFetchType,
    SQLLEN        irow,
    SQLULEN     * pcrow,
    SQLUSMALLINT    * rgfRowStatus);

SQLRETURN SQL_API SQLForeignKeys (
    SQLHSTMT          hstmt,
    SQLCHAR     * szPkCatalogName,
    SQLSMALLINT       cbPkCatalogName,
    SQLCHAR     * szPkSchemaName,
    SQLSMALLINT       cbPkSchemaName,
    SQLCHAR     * szPkTableName,
    SQLSMALLINT       cbPkTableName,
    SQLCHAR     * szFkCatalogName,
    SQLSMALLINT       cbFkCatalogName,
    SQLCHAR     * szFkSchemaName,
    SQLSMALLINT       cbFkSchemaName,
    SQLCHAR     * szFkTableName,
    SQLSMALLINT       cbFkTableName);

SQLRETURN SQL_API SQLMoreResults (
    SQLHSTMT          hstmt);

SQLRETURN SQL_API SQLNativeSql (
    SQLHDBC       hdbc,
    SQLCHAR     * szSqlStrIn,
    SQLINTEGER        cbSqlStrIn,
    SQLCHAR     * szSqlStr,
    SQLINTEGER        cbSqlStrMax,
    SQLINTEGER      * pcbSqlStr);

SQLRETURN SQL_API SQLNumParams (
    SQLHSTMT        hstmt,
    SQLSMALLINT     * pcpar);

SQLRETURN SQL_API SQLParamOptions (
    SQLHSTMT          hstmt,
    SQLULEN       crow,
    SQLULEN     * pirow);

SQLRETURN SQL_API SQLPrimaryKeys (
    SQLHSTMT          hstmt,
    SQLCHAR     * szCatalogName,
    SQLSMALLINT       cbCatalogName,
    SQLCHAR     * szSchemaName,
    SQLSMALLINT       cbSchemaName,
    SQLCHAR     * szTableName,
    SQLSMALLINT       cbTableName);

SQLRETURN SQL_API SQLProcedureColumns (
    SQLHSTMT          hstmt,
    SQLCHAR     * szCatalogName,
    SQLSMALLINT       cbCatalogName,
    SQLCHAR     * szSchemaName,
    SQLSMALLINT       cbSchemaName,
    SQLCHAR     * szProcName,
    SQLSMALLINT       cbProcName,
    SQLCHAR     * szColumnName,
    SQLSMALLINT       cbColumnName);

SQLRETURN SQL_API SQLProcedures (
    SQLHSTMT          hstmt,
    SQLCHAR     * szCatalogName,
    SQLSMALLINT       cbCatalogName,
    SQLCHAR     * szSchemaName,
    SQLSMALLINT       cbSchemaName,
    SQLCHAR     * szProcName,
    SQLSMALLINT       cbProcName);

SQLRETURN SQL_API SQLSetPos (
    SQLHSTMT          hstmt,
    SQLSETPOSIROW     irow,
    SQLUSMALLINT      fOption,
    SQLUSMALLINT      fLock);

SQLRETURN SQL_API SQLTablePrivileges (
    SQLHSTMT          hstmt,
    SQLCHAR     * szCatalogName,
    SQLSMALLINT       cbCatalogName,
    SQLCHAR     * szSchemaName,
    SQLSMALLINT       cbSchemaName,
    SQLCHAR     * szTableName,
    SQLSMALLINT       cbTableName);

SQLRETURN SQL_API SQLDrivers (
    SQLHENV       henv,
    SQLUSMALLINT      fDirection,
    SQLCHAR     * szDriverDesc,
    SQLSMALLINT       cbDriverDescMax,
    SQLSMALLINT     * pcbDriverDesc,
    SQLCHAR     * szDriverAttributes,
    SQLSMALLINT       cbDrvrAttrMax,
    SQLSMALLINT     * pcbDrvrAttr);

SQLRETURN SQL_API SQLBindParameter (
    SQLHSTMT          hstmt,
    SQLUSMALLINT      ipar,
    SQLSMALLINT       fParamType,
    SQLSMALLINT       fCType,
    SQLSMALLINT       fSqlType,
    SQLULEN       cbColDef,
    SQLSMALLINT       ibScale,
    SQLPOINTER        rgbValue,
    SQLLEN        cbValueMax,
    SQLLEN      * pcbValue);

/*
 *  Depreciated - use SQLSetStmtOptions
 */
SQLRETURN SQL_API SQLSetScrollOptions (     /* Use SQLSetStmtOptions */
    SQLHSTMT          hstmt,
    SQLUSMALLINT      fConcurrency,
    SQLLEN        crowKeyset,
    SQLUSMALLINT      crowRowset);


/*
 *  SQLAllocHandleStd - make SQLAllocHandle compatible with X/Open standard
 *
 *  NOTE: An application should not call SQLAllocHandleStd directly
 */
#ifdef ODBC_STD
#define SQLAllocHandle          SQLAllocHandleStd
#define SQLAllocEnv(phenv) \
    SQLAllocHandleStd(SQL_HANDLE_ENV, SQL_NULL_HANDLE, phenv)

#if (ODBCVER >= 0x0300)
SQLRETURN SQL_API SQLAllocHandleStd (
    SQLSMALLINT       fHandleType,
    SQLHANDLE         hInput,
    SQLHANDLE       * phOutput);
#endif


/* Internal type subcodes */
#define SQL_YEAR            SQL_CODE_YEAR
#define SQL_MONTH           SQL_CODE_MONTH
#define SQL_DAY             SQL_CODE_DAY
#define SQL_HOUR            SQL_CODE_HOUR
#define SQL_MINUTE          SQL_CODE_MINUTE
#define SQL_SECOND          SQL_CODE_SECOND
#define SQL_YEAR_TO_MONTH       SQL_CODE_YEAR_TO_MONTH
#define SQL_DAY_TO_HOUR         SQL_CODE_DAY_TO_HOUR
#define SQL_DAY_TO_MINUTE       SQL_CODE_DAY_TO_MINUTE
#define SQL_DAY_TO_SECOND       SQL_CODE_DAY_TO_SECOND
#define SQL_HOUR_TO_MINUTE      SQL_CODE_HOUR_TO_MINUTE
#define SQL_HOUR_TO_SECOND      SQL_CODE_HOUR_TO_SECOND
#define SQL_MINUTE_TO_SECOND        SQL_CODE_MINUTE_TO_SECOND
#endif  /* ODBC_STD */


#ifdef __cplusplus
}
#endif

#include <sqlucode.h>

#endif  /* _SQLEXT_H */
