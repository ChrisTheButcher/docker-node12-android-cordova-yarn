. $HOME/.bashrc

nvm use 10

VERS=$(cat package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g' \
  | tr -d '[[:space:]]')


CYPRESS_VERSION=$(echo $(cypress -v) | sed -e 's/.*version: \(.*\)Cypress.*/\1/')

echo ''
echo ''
echo '========================================='
echo '>>             SOMIA DOCKER            <<'
echo ">>            Version $VERS            <<"
echo '========================================='
echo ''
echo '   node:       '$(node -v)             
echo '   nvm:        '$(nvm --version)   
echo '   yarn:       '$(yarn -v)         
echo '   vue:        '$(vue -V)          
echo '   cordova:    '$(cordova -v)    
echo '   cypress:    '$CYPRESS_VERSION
echo ''
echo '========================================='
echo '>>    Starting Container in Bash...    <<' 
echo '========================================='
echo ''
echo ''

# bash --rcfile $HOME/.bashrc 
