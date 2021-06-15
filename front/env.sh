#!/usr/bin/env bash

# Recreate config file
rm -rf ./env-config.js
touch ./env-config.js

# Add assignment 
echo "window._env_ = {" >> ./env-config.js

# Read each line in .env file
# Each line represents key=value pairs
echo "  REACT_APP_ENV_API_URL: \"$REACT_APP_ENV_API_URL\"," >> ./env-config.js

echo "}" >> ./env-config.js
echo "apiUrl=\"$REACT_APP_ENV_API_URL\";" >> ./env-config.js
echo "console.log(\"I RAN PROPERLY\")" >> ./env-config.js


#echo "REACT_APP_ENV_API_URL=\"$REACT_APP_ENV_API_URL\"" > .env
