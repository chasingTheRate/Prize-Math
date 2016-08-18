# Prize Math

Prize Math is my first iOS app developed to be published in the App Store.  The premise is a rather simple one.  I wanted to learn swift and the iOS frameworks by developing an app that allowed parents to reward their children for learning basic arithmetic.  There are a lot of math apps for kids available but, at the time I started this project, I couldn't find one that gave the parent more control over the questions asked and the prizes awarded.  In Prize Math, the parent has the ability to define the questions asked and the rewards/prizes won by the user.  For example, a parent could quickly take a photo of a toy his or her child wanted and present it as a prize to be won.

Current App Status: BROKEN  :(  (I'm in the middle of a significant update to simplify the code and make the UI more aesthetically pleasing).

How to Play:

A user answers math questions by touching the displayed buttons and submitting answers by swiping right.  Answers can be cleared by swiping left. 

![Alt text](/Images/howToPlay.PNG?raw=true "Home")

After a predetermined number of questions are answered correctly, the app changes to a “Bonus Mode” where the user is presented with another round of math questions.  The Bonus Mode can be complicated by including a timer and/or “Complications”.  "Complications" are button animations that make selecting the number buttons more difficult.  “Gravity” and “Orbit” are shown below:

![Alt text](/Images/gravity.PNG?raw=true "Gravity") ![Alt text](/Images/orbit.PNG?raw=true "Gravity")

If the user is successful in answering the bonus questions he or she is awarded a prize. The users can access previously won prices by touching the “Prizes” tab:

![Alt text](/Images/prizeTab.PNG?raw=true "Prizes Tab")

Prizes can be claimed by swiping left on the tableviewcell:

![Alt text](/Images/claimPrize.PNG?raw=true "Claim Prize")

Settings:

The user is able to change the settings of the app by clicking on the settings icon in the navigation bar.  In Settings, the user is able to choose the type of math question, Min & Max Values, additional options, and the theme of the app. 

![Alt text](/Images/settings.PNG?raw=true "Settings") ![Alt text](/Images/settings2.PNG?raw=true "Settings")

Parental Settings:

Parents can define the bonus questions and prizes by clicking on the “Parental Settings" in the Prizes Tab (See image above).

A passcode can be set to prevent other users from changing the bonus questions and/or prizes.

![Alt text](/Images/setPasscode.PNG?raw=true "Passcode") ![Alt text](/Images/confirmPasscode.PNG?raw=true "Passcode") 

Under the Set Bonus Question option, Parents can define the bonus questions by selecting the question type, setting a complication and/or timer, and also defining the actual questions or allowing the app to create them randomly.

![Alt text](/Images/setBonus.PNG?raw=true "Set Bonus") ![Alt text](/Images/setBonus2.PNG?raw=true "Set Bonus") 

Under the Set Prize option, parents can define the prize by entering detail information and either selecting a picture from the photo library or taking one:

![Alt text](/Images/parentalSettings.PNG?raw=true "Set Prize") ![Alt text](/Images/bonusPicture.PNG?raw=true "Set Prize") ![Alt text](/Images/deletePrize.PNG?raw=true "Set Prize")

