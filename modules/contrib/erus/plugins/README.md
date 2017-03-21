# Plugins

### Github.com

#### Module Configuration

If you have private repositories you will need to provide user credentials that
can access the private repo. You may create a user in GitHub just for this
purpose and assign the user the appropriate permissions.

1. Navigate to admin/config/administration/erus
2. Click on edit for github.com
3. Enter the github username and password
4. Click submit


#### GitHub Configuration

For this module to work you will need to create releases using github's release
system. To create a release start by navigating to the projects home page.
eg: https://github.com/SU-SWS/erus

1. Navigate to the release page. eg: https://github.com/SU-SWS/erus/releases
2. Draft a new Release by clicking on the draft new release button near the top
right corner of the page.
3. Either select an already created tag by clicking into the 'tag version' field
and selecting the tag, or create a new one by typing in the name of the new tag.
You must enter Drupal compliant version names. eg: 7.x-1.0-alpha1
4. If you entered a new tag name select the target branch you wish to create the
new tag from. If you picked an already made tag continue to next step.
5. Create a release title for this release. You should have the version number
in there somewhere but it is not required.
6. Write a description about this release in the large text area. You can
include some key text lines that will be parsed by this plugin for some added
functionality. Please see below section for more details.
7. Check off 'this is a pre-release' if you are publishing an alpha or beta
8. You may save the draft for later or you can publish the release live.


#### Body Text Keys
When creating a release you may place some key text into the body of the release
notes that will be picked up and parsed by the plugin. Please be advised that
the parser is case sensitive.

*Release Types:*
For release types, have one line of comma separated values.

    eg:
    Release type: Bug fixes, New features, Security update

*MD5 Hash:*
In order to support the 'drush up' command we will have to provide the md5 hash
of the file ourselves. To enter the md5 hash of the file please provide one line
that starts with 'md5:' and is followed by the hash

    eg:
    md5: 347e56d77fa524e5c5dc21d297dffd47

If you provide your own asset you will need to provide the md5 hash up the
uploaded file. If you do not provide an uploaded asset you will need to get the
md5 hash of the 'tar.gz' download provided by github.

To get an md5 hash of a file you will need to:

1. Install md5 on your machine
2. Download or create the archive file (tar.gz)
3. Open up your terminal or console and navigate to the file
4. Run md5 your-filename.tar.gz
5. Copy the md5 hash value

