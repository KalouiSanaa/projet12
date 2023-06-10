@RestResource(urlMapping='/contracts/*')
global with sharing class ContractManager {


@HttpPost
global static String createdContract(Id accountId, String name, Date startDate, Integer contractTerm, String status) {
    Contract contract = new Contract(
       AccountId = accountId,
            Name = name,
            StartDate = startDate,
            ContractTerm = contractTerm,
           Status= status);
    insert contract;
    return contract.Id;
}

@HttpPatch
global static void updatedContract(Id accountId, String field, String value, Integer contractTerm) {
    List<Contract> contracts = [SELECT Id, ContractTerm, StartDate, EndDate, AccountId, Status FROM Contract WHERE Id = :accountId];
    if (contracts== null) {
        // Si le contrat n'existe pas, on renvoie une erreur 404
        RestContext.response.responseBody = Blob.valueOf('Contract not found.');
        RestContext.response.statusCode = 404;
    } else {
        for(contract contract :contracts){
        
        contract.ContractTerm = contractTerm;

        if (field == 'Name') {
            contract.Name = value;
        } else if (field == 'StartDate') {
            contract.StartDate = Date.valueOf(value);
        } else if (field == 'Status') {
            contract.Status = value;
        } else if (field == 'AccountId') {
            contract.AccountId = Id.valueOf(value);
        }}
        update contracts;
    }
}


}