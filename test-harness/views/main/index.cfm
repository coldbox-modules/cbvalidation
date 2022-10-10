<h2>User Form</h2>

<cfoutput>

	#flash.get( "notice", "" )#

	<form method="post" action="#event.buildLink('main/save')#">
		<h1>Local Constraint</h1>
		<div class="clearfix">
			<label for="name">Username (Required, Length: 6-20)</label>
			<div class="input">
				#html.passwordField(name="username", value=event.getValue("username",""), size="30")#
			</div>
		</div>
		<div class="clearfix">
			<label for="description">Password (Required, Length: 6-20)</label>
			<div class="input">
				#html.passwordField(name="password", value=event.getValue("password",""), size="30")#
			</div>
		</div>
		<div class="actions">
			<input type="submit" class="btn primary" value="Save" tabindex="4">
		</div>
	</form>

	<form method="post" action="#event.buildLink('main/saveShared')#">
		<h1>Shared Constraint</h1>
		<div class="clearfix">
			<label for="name">Username (Required, Length: 6-20)</label>
			<div class="input">
				#html.passwordField(name="username", value=event.getValue("username",""), size="30")#
			</div>
		</div>
		<div class="clearfix">
			<label for="description">Password (Required, Length: 6-20)</label>
			<div class="input">
				#html.passwordField(name="password", value=event.getValue("password",""), size="30")#
			</div>
		</div>
		<div class="actions">
			<input type="submit" class="btn primary" value="Save" tabindex="4">
		</div>
	</form>

</cfoutput>
