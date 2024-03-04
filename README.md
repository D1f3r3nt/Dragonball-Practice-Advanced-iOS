# Dragonball Advanced iOS

The objective of this iOS application is to put into practice knowledge obtained with Xibs,
also the knowledge of Core Data and Tests.

This application consists of a Log In, where in case of successful login, the information will be saved in Keychain,
once successfully logged in, it will show a list of dragonball superheroes, this information is obtained through an API,
also the position of these will be shown on a map and through the map or the list you can access to a detail screen.

To show the information of the list, first it will be looked in Core Data if the API call is cached, in case of not being cached the API call will be made.
API call will be made, also as an extra we have implemented a search function.
