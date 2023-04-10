@RestResource(urlMapping='/contacts/*')
global with sharing class ContactManagers {
@HttpPost
global static String newContact(String email, String firstName, String lastName) {
    List<Contact> contactExisting = [SELECT Id FROM Contact WHERE Email =:email];
    if (!contactExisting.isEmpty()) {
                contactExisting[0].FirstName = firstName;
                contactExisting[0].LastName = lastName;
                update contactExisting;
                return contactExisting[0].Id;
            
        }  else {
        // Sinon, on crée un nouveau contact dans Salesforce
        Contact newCnt = new Contact(
            FirstName=firstName,
            LastName=lastName,
            Email=email);
        insert newCnt;
        return newCnt.Id;
    }
}

@HttpPatch
global static void updatedContact(String contactId, String field, String value) {
    
    Contact contact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :contactId];
    if (contact == null) {
        // Si le contact n'existe pas, on renvoie une erreur 404
        RestContext.response.responseBody = Blob.valueOf('Contact not found.');
        RestContext.response.statusCode = 404;
    } else {
        // Sinon, on met à jour le champ spécifié et on sauvegarde le contact
         if (field == 'FirstName') {
            contact.FirstName = value;
        } else if (field == 'LastName') {
           contact.LastName = value;
        } else if (field == 'Email') {
           contact.Email=value;
        } else if (field == 'AccountId') {
            contact.AccountId = Id.valueOf(value);
        }
        update contact;
    }
}

 @HttpDelete
global static void desactivatedContact() {
   
      RestRequest request = RestContext.request;
        String contactId= request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
    try{
    Contact contact = [SELECT Id FROM Contact WHERE Id = :contactId];
    if (contact == null) {
        // Si le contact n'existe pas, on renvoie une erreur 404
        RestContext.response.responseBody = Blob.valueOf('Contact not found.');
        RestContext.response.statusCode = 404;
    } else {
        // Sinon, on désactive le contact
       contact.isActivate__c= false;
        update contact;
          RestContext.response.responseBody = Blob.valueOf('Contact ' + contact.Id + ' deactivated.');
            RestContext.response.statusCode = 200;
    }}
    catch(Exception ex){
        system.debug(ex.getMessage());
    }
}
}