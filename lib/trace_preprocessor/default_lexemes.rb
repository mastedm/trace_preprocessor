# Defalt lexemes

common_code <<-CODE
#include <time.h>
CODE

define_lexeme :ip,
  :regexp => /(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/,
  :value_kind => :exact,
  :converter => <<-CODE
    unsigned ips[4];
    sscanf(yytext, "%d.%d.%d.%d", ips, ips + 1, ips + 2, ips + 3);
    return (((ips[0] << 24) & 0xFF000000) | ((ips[1] << 16) & 0xFF0000) | ((ips[2] << 8) & 0xFF00) | (ips[3] & 0xFF));
  CODE

define_lexeme :uuid,
  :regexp => /[A-Fa-f0-9]{8}-(?:[A-Fa-f0-9]{4}-){3}[A-Fa-f0-9]{12}/,
  :value_kind => :hash,
  :converter => <<-CODE
    long x[5];
    sscanf(yytext, "%08lx-%04lx-%04lx-%04lx-%12lx", &x[0], &x[1], &x[2], &x[3], &x[4]);
    return ((((x[0] << 16) | x[1]) << 16) | x[2]) ^ ((x[3] << 48) | x[4]);
  CODE
  
define_lexeme :date,
  :regexp => /[0-9]{2}\ (?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|Nov(?:ember)?|Dec(?:ember)?)\ [0-9]{4}\ [0-9]{2}:[0-9]{2}:[0-9]{2}/,
  :value_kind => :exact,
  :converter => <<-CODE
    struct tm tm;
    time_t t;
    
    if (strptime(yytext, "%d %b %Y %H:%M:%S", &tm) == NULL) return -1;
      
    return mktime(&tm);
  CODE
