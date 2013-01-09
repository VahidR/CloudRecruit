public with sharing class recruitsController {
    /**
    These @params are intended to handle Form variables
    **/
    public String Company { get; set; }
    public String Title { get; set; }
    public String LastName { get; set; }
    public String FirstName { get; set; }

    /**
    Since we are using Custome Controller, firs we need to expose the 
    required Objects (DB Tables) to our class
    **/
    public Lead lead {get;set;}
    public Recruits__c recruit {get;set;}
    
    /**
    Add() method is kind of primitive override for save() function for Lead Object.
    It's very mininal, yet applicable for our needs. Simple and fast..
    **/
    public PageReference add() {
         Lead lead = new Lead();
         lead.FirstName = FirstName;
         lead.LastName = LastName;
         lead.Title = Title;
         lead.Company = Company;
         insert lead;
         return null; // Referesh the same page!
    }
    
    /**
    getAllContacts() method tries to populate the Lead Table
    **/    
    public List<Lead> getAllContacts(){
        return [SELECT id, FirstName, lastName, Title, Company FROM Lead];
    }
    
    /**
    Allright. Within my design, on Lead Table, I tried to add a button to each
    entity called "Recruit", meaning that recruit this person. By clecking on this
    button, a chain of actions will be happened. 
    It will take care of <apex:param>, map its "leadID" attribute and take care of 
    addToRecruits() method.
    **/
    public String leadID { get; set; }
    public PageReference addToRecruits() {
        //System.debug('LeadID is: ' + leadID);
        Lead candidate=new Lead(id=leadID); // get this candidate please
        Recruits__c r = new Recruits__c();
        for(Lead con: [SELECT FirstName, lastName FROM Lead WHERE id = :leadID]){
            r.FirstName__c = con.FirstName;
            r.LastName__c = con.LastName;
        } // populate Recruits__c object with Candidate entities ..
        
        upsert r; // remove duplicates, if any
        try{
            delete candidate;
        } catch (DmlException e) {
            System.debug(LoggingLevel.ERROR, e.getMessage());
        }
    
        // Overriding Redirection functionality 
        PageReference reference=new PageReference('/apex/recruits');
        reference.setRedirect(true);
        return reference;
    }
    
    /**
    getAllRecruits() method tries to populate the Recruits Table
    **/
    public List<Recruits__c> getAllRecruits(){
        return [SELECT FirstName__c, lastName__c FROM Recruits__c];
    }

}