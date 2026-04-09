# Tuto HTTP with Supabase

Hi everyone, welcome to this tutorial where you will learn the very basics of HTTP requests and how to set up an external database with Supabase. I did the Godot project on 4.6.2 but I'm pretty sure that you can load this on all Godot 4.+ editors. 

* [Some theory](#theory)
* [Setup Supabase](#supabase)
* [Godot HTTP playground](#godot)
* [Dig deeper](#dig-deeper) 

> [!IMPORTANT]
> All you will see here will teach you how to send data from player to a database with HTTPRequest node. Be very careful of the law in application and be sure to inform the player of the data sent. For example in Europe, if we can identify the player you enter in the GDPR section and trust me, you dont want to. More information on this example on [EU website](https://eur-lex.europa.eu/EN/legal-content/summary/general-data-protection-regulation-gdpr.html)

## Theory

First of all a bit of theory. 

### Requests

Request (client) -> Server

An HTTP request is a message sent by a client to a server. A request is composed of a URL (can be other things but most of the time this is a URL), headers (parameters), and a body (data). Only the URL is mandatory, this is kind of an address to post our request.

### Response

Client <- Response (server or error)

After sending your request, you get a response. Even if the server does not receive the request or you get something goes wrong with parameters. You get a response. And this is why HTTP is really easy to use because you can understand what goes wrong. The response gets a code. I will not list all of them here you can find them on the net easily. In short for what we need with examples:

* 2xx : Succes (201 Accepted)
* 4xx : Error from client (401 Unauthorized)
* 5xx : Error from server (500 Internal Server Error)

### Method

Requests can have several methods. To simplify I will only take the one we need for this project and for general database with CRUD principle : Create, Read, Update, Delete. The Method is applied only if the erequest is correct, the server will tell you that when you receive the Response of the request.

* Create : "POST" - you send data
* Read : "GET" - you want data
* Update : "PUT" and "PATCH" - put is to replace completely something, patch is for correct just a part of data
* Delete : "DELETE" - pew pew, destroy data

## Supabase

For this example I chose Supabase but the tool doesn't really matter. You can have Firebase, Back4App, Appwrite, homemade server with FastAPI or whatever. The logic is almost the same. The mechanism is a database on a server with an API to connect on it.

Create an account then come back here.

### Create project

> [!CAUTION]
> For the tutorial and the rest of the project, I turn off RLS and give all permission to the public API key. This is a very VERY BAD practice for production but here we just want to test. This exposes all your API to everyone but simplify testing.

First of all create project !

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_start_create_project_dashbord.png" alt="Create new project" width="640"/>

Turn on API settings.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_start_create_project_toggle_api.png" alt="Toggle the API" width="640"/>

### Create Table

Then create a table in your project.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_start_create_table_dashboard.png" alt="Dashboard table creation" width="640"/>

Put some values in it. For the project follow the step but if you want to go nuts you will have to change the `main.gd` code. I call the table `forms`, note this on side note.
The id is our `primary key` that means that each row will be unique and the data refers to this value like... like an id. You can set the fact that it will generate automatically an id (this is turned on by default).

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_table_creation_values.png" alt="Parameters to put on the table creation" width="640"/>

Here you can set RLS, we will enable it and I will show you where to set it (or disable it).

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_start_create_table_toggle_rls.png" alt="The famous RLS" width="640"/>

A pop up is shown if you want to turn it off.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_start_create_table_popup_rls.png" alt="RLS PopUp when we create Table" width="200"/>

The new table is created with nothing on it.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_table_empty.png" alt="An empty table" width="640"/>

### Table Settings

For testing, we will insert our first row, the idea here is when you do a simple HTTP request like "GET", you can read data.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_table_insert_row.png" alt="Let's insert a new row" width="200"/>

Insert some values.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_table_row_creation.png" alt="A new row creation" width="640"/>

### RLS Settings

Go to the RLS dashboard.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_rls_dashboard.png" alt="RLS Dashboard" width="640"/>

Here we can create some policies for each condition, this is the SQL version of the POST/GET/PATCH/PUT/DELETE.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_rls_creation.png" alt="New RLS" width="640"/>

For the tutorial AND THE TUTORIAL ONLY, we will disable RLS.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_rls_disabled_do_not_do_this_in_production.png" alt="Disable RLS but please dont do this for serious project" width="200"/>

Cool ! We get a database with an API to request. Now we have to get two things : the URL (for our requests) and the API key. First go to the dashboard :

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_project_dashboard_way_to_go.png" alt="Project Dashboard UX where to click" width="200"/>

Here get the id of your project (the url on the top left) and you can find the API keys at the bottom right of the dashboard. You can take the publishable API key because we disable every security.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_project_dashboard_for_finding_apikey.png" alt="Dashboard where is the API button" width="640"/>

Now to construct the url we need, we just have to add `/rest/v1/` to the url that we copied and then the table name, for example we can have `https://estuvraimententraindelireca.supabase.co/rest/v1/form`.

> But wait, do you provide hardcode the API key? Are you nuts?

Yes I hardcode only the publishable API key. But here this is dangerous because we disable security. At the end we will see a leaderdoard example where non authentified user can't post things even with a key. If you want more information on that subject, go on [Understanding API keys](https://supabase.com/docs/guides/api/api-keys) docs from Supabase.

## Godot

### The project

So, let's open the godot project. I will copy pasta the function from [`main_scene.gd`](https://github.com/Mugule/TutoHttp/blob/main/godot_files/main_scene.gd) script and the comments here. Pay attention to the `on_get_pressed`, `on_created_pressed`, `on_update_pressed` and `on_delete_pressed` functions. Everything is on it. After that, you can launch the project and I will show you the main use cases covered.

The application is a sandbox, play with it. For this tutorial you will find :
* On the top, general parameters (url + apikey to put in the header)
* On the left, a button "GET" to request your database and a console that prints response from the `HTTPRequest` node.
* On the right, three tabs to create, update or delete data.

Note : Update could have boolean to patch only the value needed because it's a "PATCH" method and not a "PUT" (reminder : "PUT" method needs all information). But I just wanted to make it simple.

### Read and Post

First of all, the "GET" method. We will put our URL and  API key directly in the panel. You can prefill them before the launch in the `MainScene` node export variables. When you press the GET Button, a request is sent to the server. If it succeeds, MainScene get triggered by the `HTTPRequest` when it gets a response with all the elements in it.

In short, this is what happens :

* Press button GET (click)
* Send Request (function)
* Get Response (signal triggered)
* Print it on console (function)

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/godot_get.png" alt="Gimme data from table" width="640"/>

And this happens everytime you press the button. If you did something wrong, the `HTTPRequest` will send back a Response with an error code and some info on the body. For example, let's do that without API key.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/godot_get_error_401_no_apikey.png" alt="No API key? all fine, you just get an error" width="640"/>

Here you can see that we get `error 401 : No API key found in request`. Not all API need an API key and some need some authentication methods or user-id. We will not cover that in this tutorial.

If you want you can put other data with the tabs "Create". Feel free to push the "GET" button again to see the results.

### Update and Delete

We can create rows but if we want to update or delete it? How to modify only the row that we want? For that, we need to apply a filter with the URL. On some database it can be done in the header but this is a bit uncommon. 

Let's check the Supabase Documentation to know what filter we need.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_api_doc_filters.png" alt="the doc with the filter" width="640"/>

Here we can see several filters. What we want is the `eq.` that means equal to. With that we can filter only on the id we want. To apply a filter, we will add some parameters to the url like this : `https://estuvraimententraindelireca.supabase.co/rest/v1/form?id=eq.5`. Let's decompose this :

* `https://estuvraimententraindelireca.supabase.co/rest/v1/form` is the url that we got from beginning
* `?` means that we will apply parameters. We can apply another with `&` as a separator (works like an AND)
* `id=eq.5` means that this value (`id`) needs to be (`=`) equals to (`eq.`) five (`5`)

When we send the request, the server will respond "OK cool bro" with the code `204`. This is the next example, in these pictures you can see those steps :
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

Supabase is way way deeper than what I just show you here. You can request table with SQL like join function, you can put some custom RLS and have an Authorization layer with account site like Discord or Steam. You can automate a lot of things here. Supabase get an "Realtime" things but to be honest I dont use it for the moment. This tutorial is just a door open to this web API world, enjoy the exploration.

[Documentation](https://supabase.com/docs/guides/api)

> Cool, but what now? What can I do with that for video games? I mean, we are here for Godot not data !

### Video Games application

That's said, here some ideas :

* Forms at the end of the demo directly in your game. No more Google Forms !
* You can take some data during the play of each level. Like this, if the player quits the game, you will know it. For example create a row in a player table, take the id (unique) and put a new row in another table with the level data (player, time to do some objective, score...).
* Lobbies can easily be done here then you can connect player with P2P. The hard things here is security.
* Don't forget that data can be read too ! With a bit of engineering you can easily do a turn based cross-platform combat. The hard things here is security.

> [!WARNING]
> Before sending HTTP requests in a real application, you usually need an authentication layer. This means that instead of directly accessing your database with a public API key, users must first prove who they are (for example with email/password, OAuth, etc.). Once authenticated, they receive a token that will be included in future requests.

### Only user can write but anyone can see

Now let's try to put a bit of security to our application. In the Authentification panel on Supabase, we will set our policies in a way that `anon` (for anonymus user) can only read and `authentificated` (for logged user) can post new row in your database. This is important because the public API key is not meant to be secret. It can safely be exposed in a client (like a Godot game) as long as proper security rules are enforced on the server side. In Supabase, this is handled with Row Level Security (RLS) policies, which define what an authenticated user is allowed to read or modify.

Ok, now let's add new policy with RLS activated.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_leaderboard_new_policy" alt="New Policy" width="640"/>

Here we can see our two policy.

<img src="https://github.com/Mugule/TutoHttp/blob/main/screenshots/supabase_leaderboard_policies" alt="New Policy" width="640"/>

So, how does it works? When a user connect, he can only see data, if he sign up. Then log in, the server will send him a temporary token to use to "POST" data on the table. But take care, by default Supabase enable email confirmation and can be annoying for player. All of this is define in the `Sign in / Provider` panel.

I don't put it in project because i'm to lazy to do UI here. But I will show you some function. You will need to declare two `var`(or `const`) to make it works : `project_url` and `api_public_key`. If you need junky but functionnal mail you can go on [YOPMail](https://yopmail.com/).

Let's do the sign-up function. Please take care of the end of the URL, this is `/auth/v1/signup` and not `/rest/v1/`.

```
func sign_up(email : String, password : String) :
	var url_sign_in = project_url + "/auth/v1/signup"
	var headers = [
		"Content-Type: application/json",
		"apikey:" + api_public_key
	]
	var body = {
		"email": email,
		"password": password
	}
	var json_body = JSON.stringify(body)
	http.request(url_sign_in, headers, HTTPClient.METHOD_POST, json_body)
```

After that the user will receive a mail. If you dont configure it adn let all by default, the user will be redirected on a local host kind of stuff. This is fine because the link work and the account created will be confirmed anyway.

After that you have to log in with the new account (you can do this automaticly if you don't use the mail confirmation part). Again the end of the URL change to `/auth/v1/token?grant_type=password`.

```
func log_in(email : String, password : String) :
	var url_token = project_url + "/auth/v1/token?grant_type=password"
	var headers = [
		"Content-Type: application/json",
		"apikey:" + api_public_key
	]
	var body = {
		"email": email,
		"password": password
	}
	var json_body = JSON.stringify(body)
	http.request(url_token, headers, HTTPClient.METHOD_POST, json_body)
```

This function will return a `acces_token` that we need.

```
{ 
    "access_token": "eyJhbGciOiJF ... 2s4UH3tZHWQ", 
    "token_type": "bearer", 
    "expires_in": 3600.0, 
    "expires_at": 1775728749.0, 
    "refresh_token": "cxvd ... oeb6", 
    "user": { 
        ...
    }
}
```

After that you will able to post data with the `acces_token` receive. To use it, you will need to add a new parameters in the `PackedStringArray` header like this : `Authorization: Bearer + acces_token`. The server will see if the user is authorized to post data or not on the specific table.

```
func post_data_with_my_super_token(data_to_post : Dictionary) :
	var header : PackedStringArray = [
		"Authorization: Bearer " + access_token,
		"apikey:" + api_public_key
		]
	var json = JSON.stringify(data_to_post)
	http.request(url, header, HTTPClient.METHOD_POST, json)
```

See this like a ticket to enter in the table. The API key identifies your project, but authentication and RLS protect your data. Even if someone extracts your public API key from your game, they won’t be able to do actions without valid authentication and matching policies. Well, they can DDOS you but who can't?

I don't do this here but it works the same with GodotSteam. You can ask him a ticket, add specific Supabase `Edge Functions` that will test the ticket with `OpenID` Steam API then authorize the user to do whatever he want.

This tutorial is open to suggestion, feel free to add more schema or anything you think can be useful !

Take care and see ya !

*Mugule*
