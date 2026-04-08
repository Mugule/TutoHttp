# Tuto HTTP with Supabase

<img src="https://github.com/Mugule/TutoHttp/blob/main/godot_francophone_icon.png" alt="Icon of the best godot community" width="200"/>

Hi everyone, welcome to this tutorial where you will learn the very basic of HTTP requests and how to setup a external database with Supabase. I did the Godot project on 4.6.2 but i'm pretty sure that you can load this on all Godot 4.+ editors. 

* [Some theory](#theory)
* [Setup Supabase](#supabase)
* [Godot HTTP playground](#godot)
* [Dig deeper](#dig-deeper) 

> [!IMPORTANT]
> All you will see here learn you how to send data from player to a database with HTTPRequest node. Be very carefull of the law in application and be sure to inform the player of the data sent. For example in europe, if we can identify the player you enter in the GDPR section and trust me, you dont want to. More information on this example on [EU website](https://eur-lex.europa.eu/EN/legal-content/summary/general-data-protection-regulation-gdpr.html])

## Theory

First of all a bit of theory. 

### Requests

Request (client) -> Server

An HTTP request is a message sent by a client to a server. A request is composed by an url (can be other things but most of time this is an url), headers (parameters), and a body (data). Only the url is mandatory, this is kind of an adress to post our request.

### Response

Client <- Response (server or error)

After sending your request, you get a response. Even if the server do not receive the request or you get something wrong with parameters. You get a response. And this is why HTTP is really easy to use because you can understand what go wrong. The response get a code. I will not list all of them here you can find them on the net easely. The most common is when you made an error on an url, 404: not found.

### Method

Requests can have several method. To spimplify I will only take the one we need for this project and for general database with CRUD principe : Create, Read, Update, Delete. The Method is apply only if the erequest is correct, the server will tell you that when you receive the Response of your request.

* Create : "POST" - you send data
* Read : "GET" - you want data
* Update : "PUT" and "PATCH" - put is to replace completely something, patch is for correct just a part of data
* Delete : "DELETE" - pew pew, destroy data

## Supabase

For this example I choose Supabase but the tool doesn't really matter. You can have Firebase, Back4App, Appwrite, homemade server with FastAPI or whatever. The logic is almost the same. The mecanisme is a database on a server with an API to connect on it.

Create an account then came back here.

### Create project

> [!CAUTION]
> For the tutorial and the rest of the project, I turn off RLS. This is a very VERY BAD practice for prodution but here we just want to test. This expose all your API to everyone but simplify testing.

First of all create project !

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_start_create_project_dashbord.png" alt="Create new project" width="640"/>

Turn on API setting.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_start_create_project_toggle_api.png" alt="Toggle the API" width="640"/>

### Create Table

Then in you project create a Table.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_start_create_table_dashboard.png" alt="Dashboard table creation" width="640"/>

Put some values in it. For the project follow the step but if you want to go nuts you will have to change the `main.gd` code. I cal the table `forms`, note this on sidenote.
The id is our `primary key` that mean that each row will be unique and the data refer to this value like... like an id. You can set the fact that it will generate automaticly an id (this is turned on by default).

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_table_creation_values.png" alt="Parameters to put on the table creation" width="640"/>

Here you can set RLS, we will set enable and I will show you where to set it (or disable it).

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_start_create_table_toggle_rls.png" alt="The famous RLS" width="640"/>

A pop up is show if you want to turn it off.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_start_create_table_popup_rls.png" alt="RLS PopUp when we create Table" width="200"/>

The new table is created with nothing on it.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_table_empty.png" alt="An empty table" width="640"/>

### Table Settings

For testing, we will insert our first row, the idea here is when you do an simple HTTP Request like "GET", you can read data.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_table_insert_row.png" alt="Let's insert a new row" width="200"/>

Insert some values.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_table_row_creation.png" alt="A new row creation" width="640"/>

### RLS Settings

RLS Setting

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_rls_dashboard.png" alt="RLS Dashboard" width="640"/>

Here we can create some policies for each condition, this is the SQL version of the POST/GET/PATCH/PUT/DELETE.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_rls_creation.png" alt="New RLS" width="640"/>

For the turorial AND THE TUTORIAL ONLY, we will disable RLS.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_rls_disabled_do_not_do_this_in_production.png" alt="Disable RLS but please dont do this for serious project" width="200"/>

Cool ! We get a database with an API to request. Now we have to get two things : the url (for our requests) and the apikey. First go to the dashboard :

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_project_dashboard_way_to_go.png" alt="Project Dashboard UX where to click" width="200"/>

Here get the id of you project (the url on the top left) and you can find the API keys at the bottom right of the dashboard. You can take the public API key because we disable every security.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_project_dashboard_for_finding_apikey.png" alt="Dashboard where is the API button" width="640"/>

Now to construct the url we need, we just have to add `/rest/v1/` to the url that we copied and then the table name, for exemple we can have `https://estuvraimententraindelireca.supabase.co/rest/v1/form`.

> [!TIP]
> I destroy all my project and table so dont try to request it.

## Godot

### The project

So, lets open the godot project. I let you check the [`main_scene.gd`](https://github.com/Mugule/TutoHttp/blob/main/godot_files/main_scene.gd) script and the comments. Pay attention to the `on_get_pressed`, `on_created_pressed`, `on_update_pressed` and `on_delete_pressed` functions. Everything is on it. After that, you can launch the project and I will show you the mains usecase covered.

The application is a sandbox, play with it. For this tutorial you will find :
* On the top, general parameters (url + apikey to put in the header)
* On the left, a button "GET" to request your database and a console that print Response from the `HTTPRequest` node.
* On the right, three tabs to create, update or delete data.

Note : Update could have boolean to patch only the value needed because its a "PATCH" method and not a "PUT" (reminder : "PUT" method need all informations). But I just wanted to make it simple.

### Read and Post

First of all, the "GET" method. We will put our url and apikey directly in the pannel. You can prefill them before the launch in the `MainScene` node export variables. When you press the GET Button, a request is send to the server. If it succed, MainScene get triggered by the `HTTPRequest` when he got a response with all the elements in it.

In short, this is what happen :
-> Press button GET (click)
-> Send Request (function)
-> Get Response (signal trigger)
-> Print it on console (function)

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/godot_get.png" alt="Gimmi data from table" width="640"/>

And this happen everytime you press the button. If you did something wrong, the `HTTPRequest` will send back a Response with an error code and some info on the body. For example, let's do that without API key.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/godot_get_error_401_no_apikey.png" alt="No API key? all fine, you just get an error" width="640"/>

Here you can see that we get `error 401 : No API key found in request`. Not all API need a API key and some need somes authentifications or some user-id. We will not cover that in this tutorial.

If you want you can put other data with the tabs "Create". Feel free to push the "GET" button again to see the results.

### Update and Delete

We can create row but if we want to update or delete it? How to modify only the row that we want? For that, we need to apply a filter with the url. On some database it can be done in the header but this is a bit uncommon. 

Let's check the Supabase Documentation to now what filter we need.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_api_doc_filters.png" alt="the doc with the filter" width="640"/>

Here we can see several filter. What we want is the `eq.` that mean equal to. With that we can filter only on the id we want. To apply a filter, we will add some parameters to the url like this : `https://estuvraimententraindelireca.supabase.co/rest/v1/form?id=eq.5`. Let's decompase this :

* `https://estuvraimententraindelireca.supabase.co/rest/v1/form` is the url that we got from beginin
* `?` means that we will apply a parameters. We can apply an other with `&` as a separator (work like an AND)
* `id=eq.5` means that this value (`id`) needs to be (`=`) equals to (`eq.`) five (`5`)

When we send the request, the server will respond "OK cool bro" with the code `204`. This is the next example, in this pictures you can see thoses steps :
* I press GET and see a row I created in the application with `a = 'Second test from Godot'`.
* I PATCH it and the server send me back `Response 204`.
* I press GET again and see the result

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/godot_update.png" alt="Update worked" width="640"/>

Same thing for the DELETE. I do a GET to see the base, with the right `id` I select the row and I delete it. I press GET to see the results.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/godot_delete.png" alt="Delete this" width="640"/>

> [!TIP]
> But what if we apply several filter when we delete or patch? What if we apply a filter on a get ? What if I spam create button and don't wait for Response? Well, enjoy testing!

### Export the results

Finally, from Supabase project, you can see your results. Download it if you want and go nuts from your fresh data !

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_export_csv.png" alt="Export data" width="640"/>

## Dig Deeper

### Supabase case

Supabase is way way deeper that what i just show you here. You can request table with SQL like join function, you can put some costum RLS and have an Authorization layer with account site like Discord or Steam. You can automate a lots of things here. Supabase get an "Realtime" things but to be honnest I dont use it for the moment. This tutorial is just a door open to this web API world, enjoy the exploration.

[Documentation](https://supabase.com/docs/guides/api)

> Cool, but what know? What can I do with that for video games? I mean, we are here for Godot not data !

### Godot application

> [!IMPORTANT]
> Reminder : be very carefull of the law in application and be sure to inform the player of the data sent. For example in europe, if we can identify the player you enter in the GDPR section and trust me, you dont want to. More information on this example on [EU website](https://eur-lex.europa.eu/EN/legal-content/summary/general-data-protection-regulation-gdpr.html])

Thats said, here somes ideas :

* Forms at the end of the demo direclty in your game. No more Google Forms !
* You can take some data during the play of each level. Like this, if the player quit the game, you will now it. For exemple create a row in a player table, take the id (unique) and put a new row in an other table with the level data (player, time to do some objective, score...).
* Lobbies can easely be done here then you can connect player with P2P. The hard things here is security.
* Don't forget that data can be read to ! With a bit of engegnering you can easely do a turn based crossplateform combat. The hard things here is security.

This tutorial is open to suggestion, feel free to had more schema or anything you thing it can be usefull !

Take care and see ya !

*Mugule*

