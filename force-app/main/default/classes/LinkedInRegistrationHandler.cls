global class LinkedInRegistrationHandler implements Auth.RegistrationHandler {
    
    global User createUser(Id portalId, Auth.UserData data){
        
        String userName = data.email.subStringBefore('@') + '@maxfit.com.organizer';
        String partnerUserName = data.email.subStringBefore('@') + '@maxfit.com.attendee';// sfdcpanther@
        
        List<User> userList = [Select Id, Name, Email, UserName 
                               From User 
                               Where ( UserName =: userName OR UserName =: partnerUserName) 
                               AND isActive = true
                              ];

        User user = new User();
        if(userList != null && userList.size() > 0){
            user = userList.get(0);
            return user;
        } else {
            
            if(data.attributeMap.containsKey('sfdc_networkid')) {
                String communityId = data.attributeMap.get('sfdc_networkid');
                // Portal User
                User u = RegistrationHandler.createPortalUser(data);
                return u;
            } else {
                // Regular User
                User u = RegistrationHandler.createUser(data);
                return u;
            }
        }
    }


    global void updateUser(Id userId, Id portalId, Auth.UserData data){
        
        List<User> userList = [Select Id, Name, Email, UserName From User Where Id =: userId AND isActive = true];
        User u = new User();
        if(userList != null && userList.size() > 0){
            u = userList.get(0);
        }
    }
}