# 2018SpringTeam30: Strategic Motion Video
# Team Members:
Zach Brownlow, Christina Mara, Will Rea, Matt Rosenbloom

## How to run:
In order to run the application via the REST end-point one should first clone this repository. Then change directories to the QA folder using git bash. From git bash run the command ./dependencies.sh and then ./run.sh. These two will set up the online server and allow you to submit questions via the URL. Copy the given IP address and paste it in to the URL bar of your browser of choice. After the IP address type /qa?question=your question here&debug&subject_id=1 where your question here is the question you want to ask. If you include debug, then extra information will be shown about how your question was matched to the questions in our database. If subject id is set to 1 then your question will be matched against our SMV question set. Any other number will cause your question to be compared to our frog question set. Here is a sample request using this method:
127.0.0.1:5000/qa?question=what is smv?&debug&subject_id=1
127.0.0.1:5000 is the IP address that should be copied from your git bash terminal after run.sh prints its output.
