trigger UpdateEmailFromExternalID on Contact (before insert, before update) {
    for (Contact contact : Trigger.new) {
        // Vérifier si le champ External_ID__c a été modifié
        if (contact.External_ID__c != null && (Trigger.isInsert || contact.External_ID__c != Trigger.oldMap.get(contact.Id).External_ID__c)) {
            // Mettre à jour la valeur du champ email avec la valeur du champ External_ID__c
            contact.Email = contact.External_ID__c;
        }
    }
}