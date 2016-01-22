###What is mean total number of steps taken per day?###
options(scipen=100, digits=1)
#histogram plot
activityNoNA <- filter(activity, !is.na(steps))
groupedByDays <- summarise(group_by(activityNoNA, date), steps = sum(steps))
ggplot(groupedByDays) + geom_histogram(aes(steps, fill=..count..), binwidth = 2000) 

#mean
mean(groupedByDays$steps) #sum(activity$steps, na.rm =TRUE)/length(unique(activity$date))

#median
median(groupedByDays$steps)


###What is the average daily activity pattern?###
groupedByInterval <- summarise(group_by(activityNoNA, interval), steps = mean(steps))
ggplot(groupedByInterval) + geom_line(aes(x = interval, y = steps, colour=steps))

#interval with maximum number of steps
max(groupedByInterval$steps)



###Imputing missing values###

#total number of missing values
sum(is.na(activity$steps))

#fill strategy
#fill  interval with it's average accros all days

#fill NA values
activityFilled <- arrange(merge(activity, groupedByInterval, by = c("interval")), date, interval)
activityFilled$steps <- ifelse(is.na(activityFilled$steps.x), activityFilled$steps.y, activityFilled$steps.x)


###What is the average daily activity pattern?
#histogram plot
filledGroupedByDays <- summarise(group_by(activityFilled, date), steps = sum(steps))
ggplot(filledGroupedByDays) + geom_histogram(aes(steps, fill=..count..), binwidth = 2000) 

#mean
mean(filledGroupedByDays$steps) #sum(activity$steps, na.rm =TRUE)/length(unique(activity$date))

#median
median(filledGroupedByDays$steps)

#### Are there differences in activity patterns between weekdays and weekends? #####
activityFilled$day <- weekdays(as.Date(activityFilled$date))
activityFilled$dayType <- as.factor(ifelse(activityFilled$day %in% c("Sunday","Saturday"), "weekend","weekday"))

filledGroupedByInterval <- summarise(group_by(activityFilled, interval, dayType), steps = mean(steps))

ggplot(filledGroupedByInterval) + geom_line(aes(x = interval, y = steps, group=dayType, colour=dayType))# + facet_grid(dayType~.)


