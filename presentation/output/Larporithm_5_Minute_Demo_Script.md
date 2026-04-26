# Larporithm 5-Minute Demo Script

## 0:00-0:30 - Opening

Hi, we built **Larporithm**. In this game, you are not the person watching videos. You are the recommendation algorithm.

Your job is to learn a viewer's hidden likes and dislikes from their reactions.

## 0:30-1:10 - Problem

Recommendation systems start with guesses. They show something, watch the reaction, update their belief, and show something else.

That loop is usually invisible. Larporithm makes it visible by turning it into a game.

## 1:10-1:50 - Game Rules

At the beginning, the viewer secretly gets a few likes and dislikes.

I do not know them. I type video titles, the AI turns those titles into categories, and then the viewer reacts.

If I hit something they like, mood and time improve. If I hit something they dislike, mood drops and time falls faster.

The analytics panel is not the truth. It is my algorithm's current guess.

## 1:50-3:50 - Live Demo

I will start broad and test a few categories.

After each title, watch three things:

- the face and mood label
- the timer
- the learned likes panel

If the mood improves, I will feed more of that direction. If the mood drops, I will avoid that category and test something else.

At the end, the game reveals the viewer's actual likes and dislikes, plus what the algorithm guessed.

## 3:50-4:30 - What Changed

For demo readiness, we added hidden randomized likes and dislikes, clearer mood feedback, a centered viewer face, safer fallback scoring if the AI request fails, and an end screen that teaches the result.

## 4:30-5:00 - Close

The point is that recommendation algorithms are not neutral lists. They learn from behavior, optimize toward feedback, and shape what people see next.

Larporithm lets people feel that feedback loop in a few minutes.
