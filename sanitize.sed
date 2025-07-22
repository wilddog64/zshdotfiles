########################################################################
# sanitize.sed ― redact sensitive strings (BSD/GNU sed compatible)
########################################################################

# 1. URLs (http, https, jdbc, rediss, ftp, etc.)
s#[[:alpha:]][[:alnum:].+%-]*://[^[:space:]]*(costco\.com|costcotravel\.com)[^[:space:]]*#REDACTED_URL#g

# 2. host: (case-insensitive)
s#[Hh][Oo][Ss][Tt]:[[:space:]]*[A-Za-z0-9._%-]+#host: REDACTED_HOST#g

# 3. externalHost:
s#[Ee][Xx][Tt][Ee][Rr][Nn][Aa][Ll][Hh][Oo][Ss][Tt]:[[:space:]]*[A-Za-z0-9._%-]+#externalHost: REDACTED_EXTERNAL_HOST#g

# 4. private IPv4 10.x.x.x / 192.168.x.x / 172.16-31.x.x
s#((10|192\.168|172\.(1[6-9]|2[0-9]|3[01]))(\.[0-9]{1,3}){3})#REDACTED_IP#g

# 5. *.internal domains
s#[A-Za-z0-9._%-]+\.internal\b#REDACTED_DNS#g

# 6. *.cluster.local domains
s#[A-Za-z0-9._%-]+\.cluster\.local\b#REDACTED_DNS#g

# 7. Bearer tokens
s#Bearer[[:space:]]+[A-Za-z0-9._%-]+#Bearer REDACTED_TOKEN#g

# 8. password / Password = "secret"
s#[Pp]assword[:=][[:space:]]*["'']?[^"' ,;%[:space:]]+#password: REDACTED#g

# 9. e-mail addresses
s#[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}#REDACTED_EMAIL#g

# 10. tenantId / repository / dbUsername / spring.datasource.username / databaseName
s#[Tt]enant[Ii]d[:=][[:space:]]*[A-Za-z0-9-]+#tenantId: REDACTED_TENANT_ID#g
s#[Rr]epository[:=][[:space:]]*[A-Za-z0-9./_-]+#repository: REDACTED_REPO#g
s#[Dd]bUsername[:=][[:space:]]*[A-Za-z0-9._-]+#dbUsername: REDACTED_DB_USER#g
s#spring\.datasource\.username[:=][[:space:]]*[A-Za-z0-9._-]+#spring.datasource.username: REDACTED_DB_USER#g
s#[Dd]atabase[Nn]ame=[^;,[:space:]]+#databaseName=REDACTED_DB#gp

###############################################################################
#  azureKeyvault  ── redact the value on the next line
/^[[:space:]]*[Aa]zure[Kk]eyvault[[:space:]]*:/{
  N
  s/\n([[:space:]]*name[[:space:]]*:[[:space:]]*)[A-Za-z0-9-]{1,24}/\
\1REDACTED_NAME/
}

#  azsureKeyvault  (old typo – keep only if you still see it)
/^[[:space:]]*[Aa]zure[Kk]eyvault[[:space:]]*:/{
  N
  s/\n([[:space:]]*name[[:space:]]*:[[:space:]]*)[A-Za-z0-9-]{1,24}/\
\1REDACTED_NAME/
}
