Instacart Shopper Challenge
=================

## Usage
1. Live: http://www.instacart.solutions
2. Applicant Landing Page: http://localhost:3000
3. Funnel Buckets: http://localhost:3000/funnels.json?start_date=2016-07-01&end_date=2017-06-14 *after db:seed*
4. Admin Dashboard: http://localhost:3000/dashboard

## Local Setup
1. `bundle install`
2. `rake db:create`
3. `rake db:migrate`
4. `rake db:seed`
5. `rails s`

## Testing
1. `rake db:test:prepare`
2. `rspec`

Features
=================

## Applicant Landing Page
The landing page has been built as a single page experience enabled by javascript.
### Validations
It uses a validate.js library to validate user input, as well as relying on html5 input validators. AJAX is used to save the users inputs server side. There are more validations that run server side to prevent abusive behaviour. If these validations fail the user will be displayed error messages on the form.

### Local Storage
Local Storage is used to save the applicants input as they progress through the application process. This enables the landing page to initalize with their current application and state in the form progression if they reload the page or come back later. If local storage is not available this feature is bypassed

### Session
After an applicant is successfully save server side a session is created and set as a cookie. This is sent on all subsequent AJAX requests and used to identify the applicant record which the shopper has created. When initializing the form state from local storage the session is established with the server in case the user has cleared their cookies but not their local storage.

### LinkedIn
The LinkedIn javascript SDK has been integrated to enable the shopper to associate their linkedin account with their application. This is an additonal feature to help expediate and facilitate the verification process. Currently the linkedin data is being saved in an associated table and is viewable by and admin via the dashboard. However, the idea was to check the applicants details against their linkedin data to quickly verify if they have used the same details. This is the beginning of a verification history that could be built for an applicant. This is an optional step for the user. Perhaps this could be moved to the initial step on the form as a way to do the entire application process..

### Start Over
The shopper is able to start over by clicking the "start over" link on the form. When this is clicked, the identitfier of the applicant record is removed from the session, the local storage is deleted and the page reloaded.

### Edit
The user has the ability to edit their applicant record by clicking the "edit appliction" link on the form. This will take them to the edit page which will require them to have an applicant record id set in their session. If this is not present they will be directed to a login page and asked to supply the email and phone number they used to create their application. If this successfully matches an applicant record it will be recorded in their session and they will be redirected to the edit page.

## Funnel endpoint
The applicant data is queried out of the SQL store using a single query which groups on the week of the `created_at` field and the `aasm_state` field. These results are then looped over once to create the necassary data structure. However in order to do this I had to utilize named functions which are unique to either SQLite or Postgres. Therefore it relies on checking which database adapter is being used and selecting the appropriate named function. Please note that this will not work for any other SQL stores.

## Admin Dashboard
### Single Page Application
I decided to put together a quick single page app to display the applicant data to an admin. I used backbone.js along with marionette.js to build it. All of the javascript has been housed in the asset pipeline. However I have isolated all external libraries to the vender/assets/ folder. It would be better to setup something like bower to manage these external asset dependencies.

I've also included a semantic-ui.js to enable some functionality (i.e modal) and calendar.js to enable date pickers. Datatables.js was also included for making tables interactive. Moment.js was added to help manage dealing with dates in an effective manner.

### UI
- The default dashboard page displays the weekly stats for the previous 2 months
- There are date range pickers to enable these result to be filtered
- Clicking on a week will display all of the applicants for that week with their application details
- If the user has connected their LinkedIn account there is a button to view their LinkedIn data in a modal
- Datatables.js is used on the table which displays all of the applicants so that an admin can easily search and filter the records

## Test Coverage
I didn't have time to complete all of my test coverage however I do have partial coverage of critical paths.

## Styling
I've used Semantic-UI to style the website and make it responsive for mobile. Their is some custom styles I introduced to tweak the design which can be found in `app/assets/stylesheets/custom.scss.erb`.

## CDN
I've setup cloudfront as my CDN to deliver all of the application assets. This was introduced in the `production.rb` file as an environment variable to that it can be changed without requiring a code deploy.

## Hosting
I've setup a production version of this application in heroku. I've register instacart.solutions via route53 and pointed my DNS records at heroku. The naked domain needed to be pointed at an S3 bucket which is then redirected to www.instacart.solutions - this is due to heroku not supplying a static IP address that an A record can be pointed at. Route53 enables you to point an A record at an alias which can be an S3 bucket setup for web hosting.

## Responsive
I've ensured that the application is responsive so that applicants have a smooth experience from a mobile device.

## Improvements
There is a lot that could be improved with this application:
- The edit applicant feature was built in a rush and does not allow a user to change their background consent or attach/remove their linkedin account. Furthermore, updates to their application are not persisted to local storage which will introduce issues when they return to the applicant landing page. I haven't checked all the corner cases here
- The design of the landing page is mediocre. I could use some design pointers and make the look and feel more appealing
- The hero image does not change based on the width of the users viewport. This is a massive pitfall for mobile devices which do not require such a large image. I'd just need to add some media queries in my css to facilitate approriate images being loaded for different screen widths
- I don't like how the form validations have been setup. Currently they live in isolation and are executed on page load. It would be great to have time to add some javascript to parse the input elements looking for a validation attribute which defines what validation should be used for that particular input field. This would enable validations to be utilized elsewhere far easier in the future.


## Time Required for challenge
I compeleted the initial requirements in under 8 hours but adding the admin dashboard and hosting ballooned my time spent out to about 10-11 hours. However I decided to put the extra time in as I enjoyed this challenge and couldn't resist the urge to add some extra bells and whistles... My commit history isn't a great indication of time spent as I was not able to out enough time aside to complete this challenge in one sitting.
