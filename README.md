# KContacts
İOS Contacts Framework Helper Class

##### Auth

```Swift
       let contact = KContacts()
       contact.requestAuth()
```

##### Fetch

```Swift
       let contact = KContacts()
       contact.requestAuth()
        
       let data = contact.fetchContacts(.number) // .name | .mail | .name     
```

##### Create

```Swift
       let contact = KContacts()
       contact.requestAuth()
       
       contact.createContact(name: "Kenan", number: "0536xxxxxxx")
```

##### Check

```Swift
       let contact = KContacts()
       contact.requestAuth()
       
       let userCheck = contact.checkContact(name: "David") // true | false | nil
```
