## Amusement Park Pass Generator
This project is a combination of Unit 4 and 5 from the iOS Tech Degree.

### Approach
The idea is that various types of entrants such as guests and employees can enter the park and access various areas such as open and restricted areas based on the permissions assigned to their group.

I created an enum for each type of entrant and then added computed properties for the various permissions meaning that if any new types of entrant are eadded in the future then then the compiler will alert me that permissions need to be added too given that the switch statement in the computed properties must be exhaustive.

Actual entrants were modelled using classes and protocols define what information each entrant type must have. For example, Child entrants must be under 5 so that type conforms to AgeIdentifiable so I can ensure they have a date of birth property that can be used to check their age.
