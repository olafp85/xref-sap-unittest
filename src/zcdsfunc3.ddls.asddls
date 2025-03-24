@ClientDependent: false
@AccessControl.authorizationCheck: #NOT_REQUIRED
define table function zCdsFunc3
returns  
{
key key1 : key;
key key2 : key;
    value : value;
} 
implemented by method zamdp=>method3; 
