# Tuto HTTP with Supabase

<img src="https://github.com/Mugule/TutoHttp/blob/main/godot_francophone_icon.png" alt="Icon of the best godot community" width="200"/>

Hi everyone, welcome to this tutorial where you will learn the very basic of HTTP Request and how to setup a external database with Supabase. I did the Godot project on 4.6.2 but i'm pretty sure that you can load this on all Godot 4.+ editors. 

* [Some theory](#theory)
* [Setup Supabase](#supabase)
* [Godot HTTP playground](#godot)
* [Dig deeper](#dig-deeper) 

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

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_start_create_table_popup_rls.png" alt="RLS PopUp when we create Table" width="640"/>

The new table is created with nothing on it.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_table_empty.png" alt="An empty table" width="640"/>

### Table Settings

For testing, we will insert our first row, the idea here is when you do an simple HTTP Request like "GET", you can read data.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_table_insert_row.png" alt="Let's insert a new row" width="640"/>

Insert some values.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_table_row_creation.png" alt="A new row creation" width="640"/>

### RLS Settings

RLS Setting

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_rls_dashboard.png" alt="RLS Dashboard" width="640"/>

Here we can create some policies for each condition, this is the SQL version of the POST/GET/PATCH/PUT/DELETE.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_rls_creation.png" alt="New RLS" width="640"/>

For the turorial AND THE TUTORIAL ONLY, we will disable RLS.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_rls_disabled_do_not_do_this_in_production.png" alt="Disable RLS but please dont do this for serious project" width="640"/>

Cool ! We get a database with an API to request. Now we have to get two things : the url (for our requests) and the apikey. First go to the dashboard :

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_project_dashboard_way_to_go.png" alt="Project Dashboard UX where to click" width="200"/>

Here get the id of you project (the url on the top left) and you can find the API keys at the bottom right of the dashboard. You can take the public API key because we disable every security.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_project_dashboard_for_finding_apikey.png" alt="Dashboard where is the API button" width="640"/>

Now to construct the url we need, we just have to add `/rest/v1/` to the url that we copied and then the table name, for exemple we can have `https://zlmmxxdzgocrnhkurcod.supabase.co/rest/v1/form`.

> [!TIP]
> I destroy all my project and table so dont try to request it.

## Godot

So, lets open the godot project. I let you check the [`main_scene.gd`](https://github.com/Mugule/TutoHttp/blob/main/godot_files/main_scene.gd) script and the comments. Pay attention to the `on_get_pressed`, `on_created_pressed`, `on_update_pressed` and `on_delete_pressed`. Everything is on it. After that, you can launch the project and i will show you the mains usecase covered.



<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/godot_get_error_401_no_apikey.png" alt="No API key? all fine, you just get an error" width="640"/>

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/godot_get.png" alt="Gimmi data" width="640"/>

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_api_doc_filters.png" alt="the doc with the filter" width="640"/>

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/godot_update.png" alt="Update worked" width="640"/>

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/godot_delete.png" alt="Delete this" width="640"/>

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_export_csv.png" alt="Export data" width="640"/>

## Dig Deeper
Several table and SQL
Custom RLS and AUthorization
Automatisation on Supabase

Forms in Demo end
Data from player
Turn based partygame
Crossplatform Lobbies
