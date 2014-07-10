#--
# Copyright (c) 2014 Nicolas Aguttes
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++
module GConnect
	class Connexion
		# Connect to Garmin Connect site with username and password
		# get last activities uploaded
		# get detailed activities either in gpx format or in tcx format

		# Constants URL
		# url for first step login
		GC_LOGIN_URL             = "https://sso.garmin.com/sso/login"
		# url when ticket obtained
		GC_LOGIN_TICKET          = "http://connect.garmin.com/post-auth/login"
		# url for last uploaded activities (to concatenate with the date), format "http://connect.garmin.com/proxy/activity-search-service-1.2/json/activities?uploadDate>2014-02-01T10:00:00,000Z"
		LAST_UPLOADED_ACTIVITIES = "http://connect.garmin.com/proxy/activity-search-service-1.2/json/activities"
		# url to get an activity detail in gpx format (to concatenate with activity number)
		ACTIVITY_GPX_URL         = "http://connect.garmin.com/proxy/activity-service-1.1/gpx/activity/" # activity global information
		# url to get an activity detail in tcx format (to concatenate with activity number)
		ACTIVITY_TCX_URL         = "http://connect.garmin.com/proxy/activity-service-1.1/tcx/activity/" # activity global information
		# url to get an activity detail in json format,  (to concatenate with activity number) do not contain the trackpoints
		ACTIVITY_JSON_URL        = "http://connect.garmin.com/proxy/activity-service-1.1/json/activity/" # activity global information

		# params to pass to the login request
		# TODO: check if all the params are really needed
		PARAMS = {
			:service => "http://connect.garmin.com/post-auth/login",
			:redirectAfterAccountLoginUrl => "http://connect.garmin.com/post-auth/login",
			:redirectAfterAccountCreationUrl => "http://connect.garmin.com/post-auth/login",
			:webhost => "olaxpw-connect00.garmin.com",
			:clientId => "GarminConnect",
			:gauthHost => "https://sso.garmin.com/sso",
			:rememberMeShown => "true",
			:rememberMeChecked => "false",
			:consumeServiceTicket => "false",
			:id => "gauth-widget",
			:embedWidget => "false",
			:cssUrl => "https://static.garmincdn.com/com.garmin.connect/ui/src-css/gauth-custom.css",
			:source => "http://connect.garmin.com/en-US/signin",
			:createAccountShown => "true",
			:openCreateAccount => "false",
			:usernameShown => "true",
			:displayNameShown => "false",
			:initialFocus => "true",
			:locale => "en"
		}
		# initialization of the connexion
		# return a the connexion object for the user and password 
		def initialize(username, password)
			@g_connexion        = Mechanize.new
			login_page          = @g_connexion.get(GC_LOGIN_URL,PARAMS)
			login_form          = login_page.form_with(:id => "login-form")
			login_form.username = username
			login_form.password = password
			connect = @g_connexion.submit(login_form)
			# get te ticket
			ticket =  connect.search("script").text[/ticket=(.*cas)/,1] 
			@g_connexion.head(GC_LOGIN_TICKET, {:ticket => ticket})
			@g_connexion
		end
		
		##get a page with mechanize
		def getpage(page)
			return @g_connexion.get(page)
		end
			

		# returns the latest activities uploaded on garmin based on the date passed
		# params:
		#  start: 0 => newest activity, limit => number of activities to get
		def latest_activities(start=0,limit=1)
			activities = @g_connexion.get(LAST_UPLOADED_ACTIVITIES, {:start => start, :limit => limit}).body
		end

		# returns activity based on the id
		# params:
		#  activity_id: garmin activity ID
		#  format: 'json', 'gpx', 'tcx'
		def activity(activity_id, format='tcx')
			case format
			when 'tcx'
				activity = @g_connexion.get(ACTIVITY_TCX_URL+activity_id).body
			when 'gpx'
				activity = @g_connexion.get(ACTIVITY_GPX_URL+activity_id).body
			when 'json'
				activity = @g_connexion.get(ACTIVITY_JSON_URL+activity_id).body
			end
		end
	end
end
