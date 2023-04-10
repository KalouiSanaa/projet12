@isTest
private class ContactManagerTest {

    @isTest 
static void testNewContactWithExistingEmail() {
 Contact existingContact = new Contact(
Email = 'testemail1@test.com',
firstName = 'kal',
lastName = 'san');
insert existingContact;
String contactId;

    Test.startTest();
    // Test creating new contact
    contactId = ContactManager.newContact('testemail1@test.com','kal','san');
     List<Contact> createdContact = [SELECT Id, Email, FirstName, LastName, IsActivate__c FROM Contact WHERE Email ='testemail1@test.com'];
    System.assertEquals('testemail1@test.com', createdContact[0].Email);
    System.assertEquals('kal', createdContact[0].FirstName);
    System.assertEquals('san', createdContact[0].LastName);

   

    // Test returning existing active contact
    System.assertEquals(existingContact.Id,ContactId);
    
}
  @isTest
    static void testNewContactNonExisting() {
        // Test scenario where contact does not exist
        String contactId = ContactManager.newContact('testemail1@test.com','kal','san');
        
        List<Contact> newContacts = [SELECT Id, FirstName, LastName FROM Contact WHERE Email = 'testemail1@test.com'];
        System.assertEquals(1, newContacts.size());
        System.assertEquals('kal', newContacts[0].FirstName);
        System.assertEquals('san', newContacts[0].LastName);
        System.assertEquals(newContacts[0].Id, contactId);
    }
    
    @isTest static void testUpdatedContact() {
        // Setup
        String email = 'testemail@test.com';
        String firstName = 'san';
        String lastName = 'kal';
        Contact contact = new Contact(Email = email, FirstName = firstName, LastName = lastName);
        insert contact;
        String contactId = contact.Id;    
        // Test updating contact
        Test.startTest();
        ContactManager.updatedContact(contactId, 'FirstName', 'san');
        Test.stopTest();
        // Verify that contact's field is updated
        Contact updatedContact = [SELECT FirstName FROM Contact WHERE Id = :contactId];
        System.assertEquals('san', updatedContact.FirstName);
    }

    @isTest
    static void testDesactivatedContact() {
         ContactManager.newContact('testemail1@test.com','san','kal');

        Contact testContact = [SELECT Id,isActivate__c FROM Contact WHERE Email ='testemail1@test.com'];
        // Set up the test REST request
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/contact/' + testContact.Id;
        RestContext.request = request;

          ContactManager.desactivatedContact();

        testContact = [SELECT Id,isActivate__c FROM Contact WHERE Id =:testContact.Id];
        System.assertEquals(false, testContact.isActivate__c);
        
       
    }

   
}