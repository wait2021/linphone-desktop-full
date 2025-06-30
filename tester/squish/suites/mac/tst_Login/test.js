import * as names from 'names.js';

function main()
{
    var app = OS.getenv("APPLICATION_NAME");
    var user = OS.getenv("SQUISH_TEST_USER1");
    var pw = OS.getenv("SQUISH_TEST_PASS1");
    startApplication(app);
    test.vp("LoginPage"); // Welcome already passed, no configurations.
}
