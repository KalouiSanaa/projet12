@isTest
private class ContractManagerTest {
    @isTest static void testCreatedContract() {
        // Create test data
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        // Call the method to create a contract
        String idContract = ContractManager.createdContract(testAccount.Id, 'contrat de test', Date.today(), 4, 'Draft');

        // Assert that the contract was created successfully
        Contract createdContract = [SELECT Id, Name, StartDate, ContractTerm, Status FROM Contract WHERE Id = :idContract];
        System.assertEquals('contrat de test', createdContract.Name);
        System.assertEquals(Date.today(), createdContract.StartDate);
        System.assertEquals(4, createdContract.ContractTerm);
        System.assertEquals('Draft', createdContract.Status);
    }

    @isTest static void testUpdatedContract() {
        // Create test data
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
        Contract testContract = new Contract(
            AccountId = testAccount.Id,
            Name = 'contrat de test',
            StartDate = Date.today(),
            ContractTerm = 4,
            Status = 'draft'
        );
        insert testContract;

        // Call the method to update a contract
        ContractManager.updatedContract(testContract.Id,'Status','Activated',4);

        // Assert that the contract was updated successfully
        Contract updatedContract = [SELECT Id, Status FROM Contract WHERE Id =:testContract.Id];
        System.assertEquals('Activated', updatedContract.Status);
    }
}