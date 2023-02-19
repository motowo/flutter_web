for(var i = 0;i < process.argv.length; i++){
  console.log("argv[" + i + "] = " + process.argv[i]);
}
const { getAuth } = require("firebase-admin/auth");
var admin = require("firebase-admin");

var serviceAccount = require("./credentials/test-1b9a9-firebase-adminsdk-fclif-de985a5a53.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

getAuth()
  .getUserByEmail(process.argv[2])
  .then(async (userRecord) => {
    // See the UserRecord reference doc for the contents of userRecord.
    console.info(`Successfully fetched user data: ${JSON.stringify(userRecord.toJSON())}`);
    const userType = 'company';
    // 付与するクレーム
    const customClaims = {
      userType: userType,
    };
    if (userRecord.customClaims.userType == userType) {
      console.info(`${userRecord.uid}にuserType=${userType}が付与されています`);
    } else {
      try {
        // userにカスタムクレームを付与
        await getAuth().setCustomUserClaims(userRecord.uid, customClaims);
        console.info(`${userRecord.uid}にuserType=${userType}が付与されました`);
      } catch (error) {
        console.error(`error: ${error}`);
      }
    }
  })
  .catch((error) => {
    console.error('Error fetching user data:', error);
  });

  console.info("done!");
