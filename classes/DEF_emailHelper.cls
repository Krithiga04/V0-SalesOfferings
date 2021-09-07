/**
* @author: Sofiane Bazizen (SpringFive)
* @description: Send Scheduling emails to the designated recipients 
* @last modified on  : 2021-0-17
* @last modified by  : Sofiane Bazizen
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   2021-0-17   Sofiane Bazizen					  Initial Version
*/
public class DEF_emailHelper {
    
    
    public class wrapper {
        
        @InvocableVariable(label='templateId' description='templateId' required=false)
        Public Id templateId;
        @InvocableVariable(label='userId' description='userId' required=true)
        Public Id userId;
        @InvocableVariable(label='whatId' description='whatId' required=true)
        Public Id whatId;
        @InvocableVariable(label='recipients' description='recipients' required=true)
        Public List<String> recipients;
        @InvocableVariable(label='technicianEmails' description='technicianEmails' required=false)
        Public List<String> technicianEmails;
        @InvocableVariable(label='orgWideAddress' description='orgWideAddress' required=false)
        Public Id orgWideAddress;
        
        
    }
    
    
    @InvocableMethod(label = 'Send Email To relevant entitled Contacts')
    public static void SendEmailToContacts(List<wrapper> wrapperList) {
        
        System.debug('@In DEF_emailHelper.SendEmailToContacts...');
        
        List<Messaging.SingleEmailMessage> mailToSend = new List<Messaging.SingleEmailMessage> ();
        String templateId;
        String userId;
        String whatId;
        List<String> recipients;
        List<String> technicianEmails;
        String orgWideAddress;
        
        for(wrapper w: wrapperList){
            
            //removing dupplicate emails
            Set<String> tempSet = new Set<String>(w.recipients);
            
            templateId = w.templateId;
            userId = w.userId;
            whatId = w.whatId;
            recipients = new List<String>(tempSet);
            technicianEmails = w.technicianEmails;
            orgWideAddress = w.orgWideAddress;
            
            System.debug('@templateId: ' + templateId);
            System.debug('@userId: ' + userId);
            System.debug('@whatId: ' + whatId);
            System.debug('@recipients: ' + recipients);
            System.debug('@technicianEmails: ' + technicianEmails);
            System.debug('@orgWideAddress: ' + orgWideAddress);
            
            //Apex Single email message
            Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(templateId, userId, whatId);
            mail.setTreatTargetObjectAsRecipient(false);
            mail.setUseSignature(false);
            mail.setToAddresses(recipients);
            if (technicianEmails != null && technicianEmails.size() > 0) { mail.setCcAddresses(technicianEmails);}
            mail.setOrgWideEmailAddressId(orgWideAddress);
            mail.setSaveAsActivity(true);
            
            //Add the List of Mail to be sent
            mailToSend.add(mail);
            
        }
        
        //Send Email
        if (mailToSend.size() > 0) {
            if(!Test.isRunningTest()){
                Messaging.sendEmail(mailToSend);
            }
        }
        
    }
}