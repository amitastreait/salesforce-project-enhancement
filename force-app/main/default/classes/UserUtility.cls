/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 09-17-2021
 * @last modified by  : Amit Singh
**/
public without sharing class UserUtility {
    
    @AuraEnabled(cacheable=true)
    public static String fetchUserName() {
        return UserInfo.getName(); // Max Fit Site Guest User
    }

    @AuraEnabled(cacheable=true)
    public static String getExperienceURL(){
        String baseUrl = Network.getLoginUrl(Network.getNetworkId());
        return baseURL;
    }
}
