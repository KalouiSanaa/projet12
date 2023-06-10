trigger UpdateEmailFromExternalID on Contact (before insert, before update) {
      for (Contact contact : Trigger.new) {
        // Vérifier si le champ Email a été modifié
          if(trigger.isInsert){
              contact.External_ID__c = contact.Email;
          }
          if(trigger.isUpdate){
              contact oldContact=Trigger.oldMap.get(contact.Id);
              if(contact.Email!= oldContact.email){
              contact.External_ID__c = contact.Email;

              }
              else if(contact.External_ID__c!=oldcontact.External_ID__c){
               contact.Email= contact.External_ID__c;   
              }
            
        }
    }
}

