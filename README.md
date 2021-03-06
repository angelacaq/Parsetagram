# Project 3 - *Parsetagram*

**Parsetagram** is a photo sharing app using Parse as its backend.

Time spent: **22** hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can sign up to create a new account using Parse authentication
- [X] User can log in and log out of his or her account
- [X] The current signed in user is persisted across app restarts
- [X] User can take a photo, add a caption, and post it to "Instagram"
- [X] User can view the last 20 posts submitted to "Instagram"
- [X] User can pull to refresh the last 20 posts submitted to "Instagram"
- [X] User can load more posts once he or she reaches the bottom of the feed using infinite Scrolling
- [X] User can tap a post to view post details, including timestamp and creation
- [X] User can use a tab bar to switch between all "Instagram" posts and posts published only by the user.

The following **optional** features are implemented:

- [X] Show the username and creation time for each post
- [X] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse.
- [X] User Profiles:
   - [X] Allow the logged in user to add a profile photo
   - [X] Display the profile photo with each post
   - [X] Tapping on a post's username or profile photo goes to that user's profile page
- [ ] User can comment on a post and see all comments for each post in the post details screen.
- [X] User can like a post and see number of likes for each post in the post details screen.
- [X] Run your app on your phone and use the camera to take the photo

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. How do you animate things?
2. How do you make autolayout less of a pain?

## Video Walkthrough

[Here's a walkthrough of implemented user stories](https://youtu.be/F1GtABQoY1I)

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library


## Notes

I had a lot of issues with the requirements, especially when it came to Parse. The sign-in persistence took an unusually long amount of time, and with everything combined, I only managed to finish requirements on Friday morning. I wish I had had an extra day or two to implement user comments, autolayout, add a front-facing camera, fix some bugs, and just spend more time on the UI, but I am satisfied with what I have considering the problems I had throughout the week.

## License

    Copyright 2016 Angela Chen

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
