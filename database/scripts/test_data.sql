--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.3
-- Dumped by pg_dump version 9.6.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = core, pg_catalog;


INSERT INTO person (person_id, username, hashed_password, email_address, about_me, is_moderator, is_enabled, created_date, last_updated_date) VALUES (1, 'onezeronine', '$2a$08$NHRmX4WACF/nQ.9n7tSPieMFKt4wkT4ebnqND0dxyU20jn7Z8OHBW', NULL, NULL, false, true, '2017-07-15 12:39:04.436757+08', '2017-07-15 12:39:04.436757+08');
INSERT INTO person (person_id, username, hashed_password, email_address, about_me, is_moderator, is_enabled, created_date, last_updated_date) VALUES (2, 'mroxas', '$2a$08$VxjHK9qRsLH9nZk1FNH5D.2gPCsMBERsMxs1A3DuwXd3.o6RYYxfS', NULL, NULL, false, true, '2017-07-15 12:39:58.017799+08', '2017-07-15 12:39:58.017799+08');
INSERT INTO person (person_id, username, hashed_password, email_address, about_me, is_moderator, is_enabled, created_date, last_updated_date) VALUES (3, 'bastiboy', '$2a$08$VEmGWQOHx7uCkyMqqwEAn.4vZPvw/8xrgj2UL7rEpeBFsPxUfNHjW', NULL, NULL, false, true, '2017-07-15 12:41:54.389655+08', '2017-07-15 12:41:54.389655+08');
INSERT INTO person (person_id, username, hashed_password, email_address, about_me, is_moderator, is_enabled, created_date, last_updated_date) VALUES (4, 'user1', '$2a$08$S2vDVJBqzckAXzwA9xnhCODuFGDr.o4ai/0U.z.OMT5yAas91iqua', NULL, NULL, false, true, '2017-07-15 12:42:28.895437+08', '2017-07-15 12:42:28.895437+08');
INSERT INTO person (person_id, username, hashed_password, email_address, about_me, is_moderator, is_enabled, created_date, last_updated_date) VALUES (5, 'user2', '$2a$08$S.zsUKv3ZVQGBZeM0LImyeBWoSFTYccSTXnX6/2V1/33xk.8u3UrO', NULL, NULL, false, true, '2017-07-15 12:46:37.026697+08', '2017-07-15 12:46:37.026697+08');
INSERT INTO person (person_id, username, hashed_password, email_address, about_me, is_moderator, is_enabled, created_date, last_updated_date) VALUES (6, 'user3', '$2a$08$jmkTlgJy6e/T3szJYi9iJOgbfWSGVDtVoWejwltNWUYxTbCmrySSy', NULL, NULL, false, true, '2017-07-15 12:48:09.123194+08', '2017-07-15 12:48:09.123194+08');
INSERT INTO person (person_id, username, hashed_password, email_address, about_me, is_moderator, is_enabled, created_date, last_updated_date) VALUES (7, 'user4', '$2a$08$ZtTHuIhvzDJP39Ke8N/GkuENgWpY3i.LQpy/4wXZ7JV3mV6veIMBu', NULL, NULL, false, true, '2017-07-15 12:49:05.27208+08', '2017-07-15 12:49:05.27208+08');
INSERT INTO person (person_id, username, hashed_password, email_address, about_me, is_moderator, is_enabled, created_date, last_updated_date) VALUES (8, 'user5', '$2a$08$8vBcCOmtJBTL8vkrCoQJa.Tonkz8PkZ9TY.vOrRhOnIdvoUydtWM2', NULL, NULL, false, true, '2017-07-15 12:49:29.586139+08', '2017-07-15 12:49:29.586139+08');

SELECT pg_catalog.setval('person_person_id_seq', 8, true);


SET search_path = posting, pg_catalog;

INSERT INTO topic (topic_id, title, author_id, upvote_count, reply_count, is_deleted, created_date, last_updated_date) VALUES (2, 'Die Bremer Stadtmusikanten - Part 1', 2, 0, 0, false, '2017-07-15 12:40:26.648586+08', '2017-07-15 12:40:26.648586+08');
INSERT INTO topic (topic_id, title, author_id, upvote_count, reply_count, is_deleted, created_date, last_updated_date) VALUES (3, 'Die Bremer Stadtmusikanten - Part 2', 2, 0, 0, false, '2017-07-15 12:40:45.850138+08', '2017-07-15 12:40:45.850138+08');
INSERT INTO topic (topic_id, title, author_id, upvote_count, reply_count, is_deleted, created_date, last_updated_date) VALUES (4, 'Die Bremer Stadtmusikanten - Part 3', 2, 0, 0, false, '2017-07-15 12:41:12.555728+08', '2017-07-15 12:41:12.555728+08');
INSERT INTO topic (topic_id, title, author_id, upvote_count, reply_count, is_deleted, created_date, last_updated_date) VALUES (5, 'Brüderchen und Schwesterchen', 3, 0, 0, false, '2017-07-15 12:42:12.64212+08', '2017-07-15 12:42:12.64212+08');
INSERT INTO topic (topic_id, title, author_id, upvote_count, reply_count, is_deleted, created_date, last_updated_date) VALUES (7, 'Is it Really Representation?', 5, 0, 0, false, '2017-07-15 12:47:14.694974+08', '2017-07-15 12:47:14.694974+08');
INSERT INTO topic (topic_id, title, author_id, upvote_count, reply_count, is_deleted, created_date, last_updated_date) VALUES (6, 'Glasshole 2.0', 4, 0, 1, false, '2017-07-15 12:46:26.295414+08', '2017-07-15 12:47:29.788922+08');
INSERT INTO topic (topic_id, title, author_id, upvote_count, reply_count, is_deleted, created_date, last_updated_date) VALUES (9, 'Daumesdick', 7, 0, 0, false, '2017-07-15 12:49:20.228497+08', '2017-07-15 12:49:20.228497+08');
INSERT INTO topic (topic_id, title, author_id, upvote_count, reply_count, is_deleted, created_date, last_updated_date) VALUES (10, 'Dornröschen', 8, 0, 1, false, '2017-07-15 12:49:49.076882+08', '2017-07-15 12:50:09.707371+08');
INSERT INTO topic (topic_id, title, author_id, upvote_count, reply_count, is_deleted, created_date, last_updated_date) VALUES (8, 'Can you make a movie about eating disorders without glamorizing them?', 6, 0, 1, false, '2017-07-15 12:48:41.408999+08', '2017-07-15 12:50:24.742072+08');
INSERT INTO topic (topic_id, title, author_id, upvote_count, reply_count, is_deleted, created_date, last_updated_date) VALUES (11, 'I’m a millennial and I share more music through Instagram Stories than any other medium', 4, 0, 1, false, '2017-07-15 12:51:28.26333+08', '2017-07-15 12:52:07.528182+08');
INSERT INTO topic (topic_id, title, author_id, upvote_count, reply_count, is_deleted, created_date, last_updated_date) VALUES (13, 'The Lost Art of Quitting', 7, 0, 0, false, '2017-07-15 12:53:45.167717+08', '2017-07-15 12:53:45.167717+08');
INSERT INTO topic (topic_id, title, author_id, upvote_count, reply_count, is_deleted, created_date, last_updated_date) VALUES (1, 'Aschenputtel', 1, 0, 3, false, '2017-07-15 12:39:45.738283+08', '2017-07-15 12:54:07.687433+08');
INSERT INTO topic (topic_id, title, author_id, upvote_count, reply_count, is_deleted, created_date, last_updated_date) VALUES (17, 'Ancient Transatlantic Misadventure', 5, 0, 0, false, '2017-07-15 12:57:38.481541+08', '2017-07-15 12:57:38.481541+08');
INSERT INTO topic (topic_id, title, author_id, upvote_count, reply_count, is_deleted, created_date, last_updated_date) VALUES (19, 'Free expression isn’t a function of the values of a place but the structure of the information infrastructure.', 5, 0, 0, false, '2017-07-15 12:58:40.625067+08', '2017-07-15 12:58:40.625067+08');
INSERT INTO topic (topic_id, title, author_id, upvote_count, reply_count, is_deleted, created_date, last_updated_date) VALUES (18, 'Why you should care about Net Neutrality', 5, 0, 1, false, '2017-07-15 12:58:22.903976+08', '2017-07-15 12:59:07.838371+08');
INSERT INTO topic (topic_id, title, author_id, upvote_count, reply_count, is_deleted, created_date, last_updated_date) VALUES (15, 'Von dem Fischer un syner Fru', 7, 0, 1, false, '2017-07-15 12:55:33.300281+08', '2017-07-15 12:59:17.33398+08');
INSERT INTO topic (topic_id, title, author_id, upvote_count, reply_count, is_deleted, created_date, last_updated_date) VALUES (14, 'Did steam eat the world?', 6, 0, 2, false, '2017-07-15 12:54:56.779554+08', '2017-07-15 12:59:29.606621+08');
INSERT INTO topic (topic_id, title, author_id, upvote_count, reply_count, is_deleted, created_date, last_updated_date) VALUES (20, 'Apple’s Next Move? It’s Obvious. But We’re Missing It.', 4, 0, 0, false, '2017-07-15 12:59:56.337152+08', '2017-07-15 12:59:56.337152+08');
INSERT INTO topic (topic_id, title, author_id, upvote_count, reply_count, is_deleted, created_date, last_updated_date) VALUES (12, 'How I’m using Instagram Stories', 5, 0, 2, false, '2017-07-15 12:53:08.339857+08', '2017-07-15 13:00:16.047178+08');
INSERT INTO topic (topic_id, title, author_id, upvote_count, reply_count, is_deleted, created_date, last_updated_date) VALUES (22, 'Froschkönig', 7, 0, 0, false, '2017-07-15 13:01:12.632932+08', '2017-07-15 13:01:12.632932+08');
INSERT INTO topic (topic_id, title, author_id, upvote_count, reply_count, is_deleted, created_date, last_updated_date) VALUES (21, 'Is the Homepod a diversionary play?', 4, 0, 1, false, '2017-07-15 13:00:32.340348+08', '2017-07-15 13:01:30.829638+08');
INSERT INTO topic (topic_id, title, author_id, upvote_count, reply_count, is_deleted, created_date, last_updated_date) VALUES (16, 'Aiming for perfection in writing', 5, 0, 1, false, '2017-07-15 12:56:42.160946+08', '2017-07-15 13:01:46.54716+08');

SELECT pg_catalog.setval('topic_topic_id_seq', 22, true);


ALTER TABLE posting.post
DROP CONSTRAINT topic_parent_post_id_fkey;

INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (2, NULL, 2, 2, 'Die Bremer Stadtmusikanten - Part 1', 'Es war einmal ein Mann, der hatte einen Esel, welcher schon lange Jahre unverdrossen die Säcke in die Mühle getragen hatte. Nun aber gingen die Kräfte des Esels zu Ende, so daß er zur Arbeit nicht mehr taugte. Da dachte der Herr daran, ihn wegzugehen. Aber der Esel merkte, daß sein Herr etwas Böses im Sinn hatte, lief fort und machte sich auf den Weg nach Bremen. Dort, so meinte er, könnte er ja Stadtmusikant werden.
Als er schon eine Weile gegangen war, fand er einen Jagdhund am Wege liegen, der jämmerlich heulte. "Warum heulst du denn so, Packan?" fragte der Esel.

"Ach", sagte der Hund, "weil ich alt bin, jeden Tag schwächer werde und auch nicht mehr auf die Jagd kann, wollte mich mein Herr totschießen. Da hab ich Reißaus genommen. Aber womit soll ich nun mein Brot verdienen?"

"Weißt du, was", sprach der Esel, "ich gehe nach Bremen und werde dort Stadtmusikant. Komm mit mir und laß dich auch bei der Musik annehmen. Ich spiele die Laute, und du schlägst die Pauken." Der Hund war einverstanden, und sie gingen mitsammen weiter.

Es dauerte nicht lange, da sahen sie eine Katze am Wege sitzen, die machte ein Gesicht wie drei Tage Regenwetter. "Was ist denn dir in die Quere gekommen, alter Bartputzer?" fragte der Esel.

"Wer kann da lustig sein, wenn''s einem an den Kragen geht", antwortete die Katze. "Weil ich nun alt bin, meine Zähne stumpf werden und ich lieber hinter dem Ofen sitze und spinne, als nach Mäusen herumjage, hat mich meine Frau ersäufen wollen. Ich konnte mich zwar noch davonschleichen, aber nun ist guter Rat teuer. Wo soll ich jetzt hin?"

"Geh mit uns nach Bremen! Du verstehst dich doch auf die Nachtmusik, da kannst du Stadtmusikant werden."', 0, 0, false, false, '2017-07-15 12:40:26.648586+08', '2017-07-15 12:40:26.648586+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (3, NULL, 3, 2, 'Die Bremer Stadtmusikanten - Part 2', 'Die Katze hielt das für gut und ging mit. Als die drei so miteinander gingen, kamen sie an einem Hof vorbei. Da saß der Haushahn auf dem Tor und schrie aus Leibeskräften. "Du schreist einem durch Mark und Bein", sprach der Esel, "was hast du vor?"

"Die Hausfrau hat der Köchin befohlen, mir heute abend den Kopf abzusschlagen. Morgen, am Sonntag, haben sie Gäste, da wollen sie mich in der Suppe essen. Nun schrei ich aus vollem Hals, solang ich noch kann."

"Ei was" sagte der Esel, "zieh lieber mit uns fort, wir gehen nach Bremen, etwas Besseres als den Tod findest du überall. Du hast eine gute Stimme, und wenn wir mitsammen musizieren, wird es gar herrlich klingen."

Dem Hahn gefiel der Vorschlag, und sie gingen alle vier mitsammen fort. Sie konnten aber die Stadt Bremen an einem Tag nicht erreichen und kamen abends in einen Wald, wo sie übernachten wollten. Der Esel und der Hund legten sich unter einen großen Baum, die Katze kletterte auf einen Ast, und der Hahn flog bis in den Wipfel, wo es am sichersten für ihn war.

Ehe er einschlief, sah er sich noch einmal nach allen vier Windrichtungen um. Da bemerkte er einen Lichtschein. Er sagte seinen Gefährten, daß in der Nähe ein Haus sein müsse, denn er sehe ein Licht.

Der Esel antwortete: "So wollen wir uns aufmachen und noch hingehen, denn hier ist die Herberge schlecht." Der Hund meinte, ein paar Knochen und etwas Fleisch daran täten ihm auch gut.

Also machten sie sich auf den Weg nach der Gegend, wo das Licht war. Bald sahen sie es heller schimmern, und es wurde immer größer, bis sie vor ein hellerleuchtetes Räuberhaus kamen. Der Esel, als der größte, näherte sich dem Fenster und schaute hinein.

"Was siehst du, Grauschimmel?" fragte der Hahn.

"Was ich sehe?" antwortete der Esel. "Einen gedeckten Tisch mit schönem Essen und Trinken, und Räuber sitzen rundherum und lassen sich''s gutgehen!"

"Das wäre etwas für uns", sprach der Hahn.

Da überlegten die Tiere, wie sie es anfangen könnten, die Räuber hinauszujagen. Endlich fanden sie ein Mittel. Der Esel stellte sich mit den Vorderfüßen auf das Fenster, der Hund sprang auf des Esels Rücken, die Katze kletterte auf den Hund, und zuletzt flog der Hahn hinauf und setzte sich der Katze auf den Kopf. Als das geschehen war, fingen sie auf ein Zeichen an, ihre Musik zu machen: der Esel schrie, der Hund bellte, die Katze miaute, und der Hahn krähte. Darauf stürzten sie durch das Fenster in die Stube hinein, daß die Scheiben klirrten.', 0, 0, false, false, '2017-07-15 12:40:45.850138+08', '2017-07-15 12:40:45.850138+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (4, NULL, 4, 2, 'Die Bremer Stadtmusikanten - Part 3', 'Die Räuber fuhren bei dem entsetzlichen Geschrei in die Höhe. Sie meinten, ein Gespenst käme herein, und flohen in größter Furcht in den Wald hinaus.

Nun setzten sie die vier Gesellen an den Tisch, und jeder aß nach Herzenslust von den Speisen, die ihm am besten schmeckten.

Als sie fertig waren, löschten sie das Licht aus, und jeder suchte sich eine Schlafstätte nach seinem Geschmack. Der Esel legte sich auf den Mist, der Hund hinter die Tür, die Katze auf den Herd bei der warmen Asche, und der Hahn flog auf das Dach hinauf. Und weil sie müde waren von ihrem langen Weg, schliefen sie bald ein.

Als Mitternacht vorbei war und die Räuber von weitem sahen, daß kein Licht mehr im Haus brannte und alles ruhig schien, sprach der Hauptmann: "Wir hätten uns doch nicht sollen ins Bockshorn jagen lassen." Er schickte einen Räuber zurück, um nachzusehen, ob noch jemand im Hause wäre.

Der Räuber fand alles still. Er ging in die Küche und wollte ein Licht anzünden. Da sah er die feurigen Augen der Katze und meinte, es wären glühende Kohlen. Er hielt ein Schwefelhölzchen daran, daß es Feuer fangen sollte. Aber die Katze verstand keinen Spaß, sprang ihm ins Gesicht und kratzte ihn aus Leibeskräften. Da erschrak er gewaltig und wollte zur Hintertür hinauslaufen. Aber der Hund, der da lag, sprang auf und biß ihn ins Bein. Als der Räuber über den Hof am Misthaufen vorbeirannte, gab ihm der Esel noch einen tüchtigen Schlag mit dem Hinterfuß. Der Hahn aber, der von dem Lärm aus dem Schlaf geweckt worden war, rief vom Dache herunter: "Kikeriki!"

Da lief der Räuber, was er konnte, zu seinem Hauptmann zurück und sprach: "Ach, in dem Haus sitzt eine greuliche Hexe, die hat mich angehaucht und mir mit ihren langen Fingern das Gesicht zerkratzt. An der Tür steht ein Mann mit einem Messer, der hat mich ins Bein gestochen. Auf dem Hof liegt ein schwarzes Ungetüm, das hat mit einem Holzprügel auf mich losgeschlagen. Und oben auf dem Dache, da sitzt der Richter, der rief: ''Bringt mir den Schelm her!'' Da machte ich, daß ich fortkam."

Von nun an getrauten sich die Räuber nicht mehr in das Haus. Den vier Bremer Stadtmusikanten aber gefiel''s darin so gut, daß sie nicht wieder hinaus wollten.', 0, 0, false, false, '2017-07-15 12:41:12.555728+08', '2017-07-15 12:41:12.555728+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (5, NULL, 5, 3, 'Brüderchen und Schwesterchen', 'Brüderchen nahm sein Schwesterchen an der Hand und sprach: "Seit die Mutter tot ist, haben wir keine gute Stunde mehr; die Stiefmutter schlägt uns alle Tage und stößt uns mit den Füßen fort. Die harten Brotkrusten, die übrigbleiben, sind unsere Speise, und dem Hündchen unter dem Tisch geht''s besser, dem wirft sie doch manchmal einen guten Bissen zu. Daß Gott erbarm, wenn das unsere Mutter wüßte! Komm, wir wollen miteinander in die weite Welt gehen."

Sie gingen den ganzen Tag, und wenn es regnete, sprach das Schwesterlein: "Gott und unsere Herzen, die weinen zusammen!" Abends kamen sie in einen großen Wald und waren so müde von Jammer, vom Hunger und von dem langen Weg, daß sie sich in einen hohlen Baum setzten und einschliefen.

Am andern Morgen, als sie aufwachten, stand die Sonne schon hoch am Himmel und schien heiß in den Baum hinein. Da sprach das Brüderchen: "Schwesterchen, mich dürstet, wenn ich ein Brünnlein wüßte, ich ging'' und tränk'' einmal; ich mein'', ich hört'' eins rauschen."

Brüderchen stand auf, nahm Schwesterchen an der Hand, und sie wollten das Brünnlein suchen. Die böse Stiefmutter aber war eine Hexe und hatte wohl gesehen, wie die beiden Kinder fortgegangen waren, war ihnen nachgeschlichen, heimlich, wie die Hexen schleichen, und hatte alle Brunnen im Walde verwünscht.

Als sie nun ein Brünnlein fanden, das so glitzerig über die Steine sprang, wollte das Brüderchen daraus trinken; aber das Schwesterchen hörte, wie es im Rauschen sprach:

"Wer aus mir trinkt, wird ein Tiger, 
wer aus mir trinkt, wird ein Tiger."
Da rief das Schwesterchen: "Ich bitte dich, Brüderchen, trink nicht, sonst wirst du ein wildes Tier und zerreißt mich." Das Brüderchen trank nicht, obgleich es so großen Durst hatte, und sprach: "Ich will warten bis zur nächsten Quelle."

Als sie zum zweiten Brünnlein kamen, hörte das Schwesterchen, wie auch dieses sprach:

"Wer aus mir trinkt, wird ein Wolf, 
wer aus mir trinkt, wird ein Wolf."
Da rief das Schwesterchen: "Brüderchen, ich bitte dich, trink nicht, sonst wirst du ein Wolf und frissest mich." Das Brüderchen trank nicht und sprach: "Ich will warten, bis wir zur nächsten Quelle kommen, aber dann muß ich trinken, du magst sagen, was du willst; mein Durst ist gar zu groß."

Und als sie zum dritten Brünnlein kamen, hörte das Schwesterlein, wie es im Rauschen sprach:

"Wer aus mir trinkt, wird ein Reh, 
wer aus mir trinkt, wird ein Reh."
Das Schwesterchen sprach: "Ach, Brüderchen, trink nicht, sonst wirst du ein Reh und läufst mir fort." Aber das Brüderchen hatte sich gleich beim Brünnlein niedergekniet, und von dem Wasser getrunken, und wie die ersten Tropfen auf seine Lippen gekommen waren, lag es da als ein Rehkälbchen.

Nun weinte das Schwesterchen über das arme verwünschte Brüderchen, und das Rehchen weinte auch und Saß so traurig neben ihm. Da sprach das Mädchen endlich: "Sei still, liebes Rehchen, ich will dich ja nimmermehr verlassen." Dann band es sein goldenes Strumpfband ab und tat es dem Rehchen um den Hals und rupfte Binsen und flocht ein weiches Seil daraus. Daran band es das Tierchen und führte es weiter und ging immer tiefer in den Wald hinein.

Und als sie lange, lange gegangen waren, kamen sie endlich an ein kleines Haus, und das Mädchen schaute hinein, und weil es leer war, dachte es: "Hier können wir bleiben und wohnen." Da suchte es dem Rehchen Laub und Moos zu einem weichen Lager, und jeden Morgen ging es aus und sammelte Wurzeln, Beeren und Nüsse, und für das Rehchen brachte es zartes Gras mit, war vergnügt und spielte vor ihm herum. Abends, wenn Schwesterchen müde war und sein Gebet gesagt hatte, legte es seinen Kopf auf den Rücken des Rehkälbchens, das war sein Kissen, darauf es sanft einschlief. Und hätte das Brüderchen nur seine menschliche Gestalt gehabt, es wäre ein herrliches Leben gewesen.

Das dauerte eine Zeitlang, daß sie so allein in der Wildnis waren. Es trug sich aber zu, daß der König des Landes eine große Jagd in dem Wald hielt. Da schallte das Hörnerblasen, Hundegebell und das lustige Geschrei der Jäger durch die Bäume, und das Rehlein hörte es und wäre gar zu gerne dabeigewesen.

"Ach", sprach es zum Schwesterlein, "laß mich hinaus in die Jagd, ich kann''s nicht länger mehr aushalten", und bat so lange, bis es einwilligte. "Aber", sprach es zu ihm, "komm mir ja abends wieder, vor den wilden Jägern schließ'' ich mein Türlein; und damit ich dich kenne, so klopf und sprich: ''Mein Schwesterlein, laß mich herein!'' Und wenn du nicht so sprichst, so schließ ich mein Türlein nicht auf."

Nun sprang das Rehchen hinaus und es war ihm so wohl und es war so lustig in freier Luft. Der König und seine Jäger sahen das schöne Tier und setzten ihm nach, aber sie konnten es nicht einholen, und wenn sie meinten, sie hätten es gewiß, da sprang es über das Gebüsch weg und war verschwunden. Als es dunkel ward, lief es zu dem Häuschen, klopfte und sprach: "Mein Schwesterlein, laß mich herein." Da ward ihm die kleine Tür aufgetan, es sprang hinein und ruhete sich die ganze Nacht auf seinem weichen Lager aus.

Am andern Morgen ging die Jagd von neuem an, und als das Rehlein wieder das Hifthorn hörte und das "Ho ho!" der Jäger, da hatte es keine Ruhe und sprach: "Schwesterchen, mach mir auf, ich muß hinaus." Das Schwesterchen öffnete ihm die Tür und sprach: "Aber zu Abend mußt du wieder da sein und dein Sprüchlein sagen." Als der König und seine Jäger das Rehlein mit dem goldenen Halsband wiedersahen, jagten sie ihm alle nach, aber es war ihnen zu schnell und behend. Das währte den ganzen Tag, endlich aber hatten es die Jäger abends umzingelt, und einer verwundete es ein wenig am Fuß, so daß es hinken mußte und langsam fortlief.

Da schlich ihm ein Jäger nach bis zu dem Häuschen und hörte, wie es rief: "Mein Schwesterlein, laß mich herein", und sah, daß die Tür ihm aufgetan und alsbald wieder zugeschlossen ward. Der Jäger ging zum König und erzählte ihm, was er gesehen und gehört hatte. Da sprach der König: "Morgen soll noch einmal gejagt werden."

Das Schwesterchen aber erschrak gewaltig, als es sah, daß sein Rehkälbchen verwundet war. Es wusch ihm das Blut ab, legte Kräuter auf und sprach: "Geh auf dein Lager, lieb Rehchen, daß du wieder heil wirst." Die Wunde aber war so gering, daß das Rehchen am Morgen nichts mehr davon spürte. Und als es die Jagdlust wieder draußen hörte, sprach es: "Ich kann''s nicht aushalten, ich muß dabeisein!"

Das Schwesterchen weinte und sprach: "Nun werden sie dich töten, und ich bin hier allein im Wald und bin verlassen von aller Welt, ich lass'' dich nicht hinaus."

"So sterb'' ich dir hier vor Betrübnis", antwortete das Rehchen, "wenn ich das Hifthorn höre, so mein'' ich, ich müßt'' aus den Schuhen springen!"

Da konnte das Schwesterchen nicht anders und schloß ihm mit schwerem Herzen die Tür auf, und das Rehchen sprang gesund und fröhlich in den Wald. Als es der König erblickte, sprach er zu seinen Jägern: "Nun jagt ihm nach den ganzen Tag bis in die Nacht, aber daß ihm keiner etwas zuleide tut." Sobald die Sonne untergegangen war, sprach der König zum Jäger: "Nun komm und zeige mir das Waldhäuschen." Und als er vor dem Türlein war, klopfte er an und rief: "Lieb Schwesterlein, laß mich herein."

Da ging die Tür auf, und der König trat herein, und da stand ein Mädchen, das war so schön, wie er noch keines gesehen hatte. Das Mädchen erschrak, als es sah, daß ein Mann hereinkam, der eine goldene Krone auf dem Haupt hatte. Aber der König sah es freundlich an, reichte ihm die Hand und sprach: "Willst du mit mir gehen auf mein Schloß und meine liebe Frau sein?"

"Ach ja", antwortete das Mädchen, "aber das Rehchen muß auch mit, das verlass'' ich nicht."

Sprach der König: "Es soll bei dir bleiben, solange du lebst, und es soll ihm an nichts fehlen." Indem kam es hereingesprungen; da band es das Schwesterchen wieder an das Binsenseil, nahm es selbst in die Hand und ging mit ihm aus dem Waldhäuschen fort. Der König nahm das schöne Mädchen auf sein Pferd und führte es in sein Schloß, wo die Hochzeit mit großer Pracht gefeiert wurde, und es war nun die Frau Königin, und sie lebten lange Zeit vergnügt zusammen; das Rehlein ward gehegt und gepflegt und sprang in dem Schloßgarten herum.

Die böse Stiefmutter aber, um derentwillen die Kinder in die Welt hineingegangen waren, die meinte nicht anders als, Schwesterchen wäre von den wilden Tieren im Walde zerrissen worden und Brüderchen als ein Rehkalb von den Jägern totgeschossen. Als sie nun hörte, daß sie so glücklich waren und es ihnen so wohlging, da wurden Neid und Mißgunst in ihrem Herzen rege und ließen ihr keine Ruhe, wie sie die beiden doch noch ins Unglück bringen könnte.

Ihre rechte Tochter, die häßlich war wie die Nacht und nur ein Auge hatte, die machte ihr Vorwürfe und sprach: Eine Königin zu werden, das Glück hätte mir gebührt."

"Sei nur still", sagte die Alte und sprach sie zufrieden, wenn''s Zeit ist, will ich schon bei der Hand sein."

Als nun die Zeit herangerückt war und die Königin ein schönes Knäblein zur Welt gebracht hatte und der König gerade auf der Jagd war, nahm die alte Hexe die Gestalt der Kammerfrau an, trat in die Stube, wo die Königin lag, und sprach zu der Kranken: "Kommt, das Bad ist fertig, das wird Euch wohltun und frische Kräfte geben; geschwind, eh'' es kalt wird." Ihre Tochter war auch bei der Hand, sie trugen die schwache Königin in die Badstube und legten sie in die Wanne. Dann schlossen sie die Türe ab und liefen davon. In der Badstube aber hatten sie ein rechtes Höllenfeuer angemacht, daß die schöne junge Königin bald ersticken mußte.

Als das vollbracht war, nahm die Alte ihre Tochter, setzte ihr eine Haube auf und legte sie ins Bett an der Königin Stelle. Sie gab ihr auch die Gestalt und das Ansehen der Königin; nur das verlorene Auge konnte sie ihr nicht wiedergeben. Damit es aber der König nicht merkte, mußte sie sich auf die Seite legen, wo sie kein Auge hatte. Am Abend, als er heimkam und hörte, daß ihm ein Söhnlein geboren war, freute er sich herzlich und wollte ans Bett seiner lieben Frau gehen und sehen, was sie machte. Da rief die Alte geschwind: "Beileibe, laßt die Vorhänge zu, die Königin darf noch nicht ins Licht sehen und muß Ruhe haben." Der König ging zurück und wußte nicht, daß eine falsche Königin im Bette lag.

Als es aber Mitternacht war und alles schlief, da sah die Kinderfrau, die in der Kinderstube neben der Wiege saß und allein noch wachte, wie die Tür aufging und die rechte Königin hereintrat. Sie nahm das Kind aus der Wiege, legte es in ihren Arm und gab ihm zu trinken. Dann schüttelte sie ihm sein Kißchen, legte es wieder hinein. Sie vergaß aber auch das Rehchen nicht, ging in die Ecke, wo es lag, und streichelte ihm über den Rücken. Darauf ging sie wieder zur Tür hinaus, und die Kinderfrau fragte am andern Morgen die Wächter, ob jemand während der Nacht ins Schloß gegangen wäre, aber sie antworteten: "Nein, wir haben niemand gesehen." So kam sie viele Nächte und sprach niemals ein Wort dabei; die Kinderfrau sah sie immer, aber sie getraute sich nicht, jemand etwas davon zu sagen.

Als nun so eine Zeit verflossen war, da hub die Königin in der Nacht an zu reden und sprach:

"Was macht mein Kind?
Was macht mein Reh?
Nun komm'' ich noch zweimal
Und dann nimmermehr."
Die Kinderfrau antwortete ihr nicht, aber als sie wieder verschwunden war, ging sie zum König und erzählte ihm alles. Sprach der König: "Ach Gott, was ist das? Ich will in der nächsten Nacht bei dem Kinde wachen." Abends ging er in die Kinderstube, aber um Mitternacht erschien die Königin und sprach:

"Was macht mein Kind?
Was macht mein Reh?
Nun komm'' ich noch einmal
Und dann nimmermehr"
und pflegte dann das Kind, wie sie gewöhnlich tat, ehe sie verschwand. Der König getraute sich nicht, sie anzureden, aber er wachte auch in der folgenden Nacht. Sie sprach abermals:

"Was macht mein Kind?
Was macht mein Reh?
Nun komm'' ich noch diesmal
Und dann nimmermehr."
Da konnte sich der König nicht zurückhalten, sprang zu ihr und sprach: "Du kannst niemand anders sein als meine liebe Frau." Da antwortete sie: "Ja, ich bin deine liebe Frau", und hatte in dem Augenblick durch Gottes Gnade das Leben wiedererhalten, war frisch, rot und gesund.

Darauf erzählte sie dem König den Frevel, den die böse Hexe und ihre Tochter an ihr verübt hatten. Der König ließ beide vor Gericht führen, und es ward ihnen das Urteil gesprochen. Die Tochter ward in den Wald geführt, wo sie die wilden Tiere zerrissen, die Hexe aber ward ins Feuer gelegt und mußte jammervoll verbrennen. Und wie sie zu Asche verbrannt war, verwandelte sich das Rehkälbchen und erhielt seine menschliche Gestalt wieder; Schwesterchen und Brüderchen aber lebten glücklich zusammen bis an ihr Ende.', 0, 0, false, false, '2017-07-15 12:42:12.64212+08', '2017-07-15 12:42:12.64212+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (7, NULL, 7, 5, 'Is it Really Representation?', 'Growing up, I would watch TV shows and movies where all the characters were white. I wondered if people who looked like me were allowed to exist on screen. On the rare occasions where someone that looked like me was depicted, they would be a token character just there for the accent and subtle racial jokes.

There has been a boost in recent years to cast people who look like me. This was making my childhood dream come true except for one slight issue: only men were getting star roles. Sure, Hollywood is a sexist industry where male actors get more attention than their counterparts, but it’s really emphasized in the South Asian demographics.

When it comes to South Asian male representation there is something qwhite off about it. Aziz Ansari’s Netflix show Master of None was the first critically acclaimed series that starred a South Asian as the main character. Aziz’s character was a “forward thinking” son of immigrant parents. Throughout the show he would dismiss his parents’ culture in favor of his white peers’ lifestyle. Their culture was too antiquated for his American traditions (to avoid lifestyle repetition) and he never really made an attempt to embrace it.

Somehow, the only characters that are allowed to be represented are ones that dismiss their parents’ culture and embrace the American way of life. Instead of using their platforms to explore the internal struggle that diasporas have with balancing the two, they just skip over that and go full American. Is it because the only palatable South Asian is one that is white washed?
The trend of “white washing” these South Asian characters continues in Kumail Nanjiani’s film The Big Sick, a true story based on he and his wife’s life. Kumail is often found dismissing his Pakistan culture when it suits him. Often he would lie to his parents about praying, he would drink alcohol, have premarital sex, and, the worst offense of all, he prefered ice cream over kulfi. Yet he still uses his culture as a prop for his one person play, which comes across as if he doesn’t care about his culture all that much.
While these male South Asian diaspora characters are praised by society for their American lifestyles, female South Asian diaspora characters like Mindy Kaling are criticized for it. When Mindy Kaling’s character on the show The Mindy Project was dismissive of her parents’ Hindu rituals and cultures, she was met with criticism over belittling the religion. Contrast this to the praises and support that Aziz’s episode about dismissing his parent’s Muslim rituals and culture on Master of None received. Critics called that and Kumail’s secular views of Islam as inspiring and relatable. Mindy’s character was called out for being too white-washed yet Kumail was cheered on for pleading with his parents to allow him to be American.

Why do male diaspora get a pass on being white washed yet female diaspora face the brunt of criticism?
On the topic of female South Asian characters, representation outside of The Mindy Project has left a lot to be desired. There are no female South Asian led movies or shows, besides The Mindy Project and Priyanka Chopra’s Quantico. Female South Asian characters are shown as a prop in these male South Asian starred shows and movies.
During Master of None, there was not one South Asian female character in the first season. Possibly due to criticism, Aziz decided to include two of them in the next season. He goes on a Tinder date and is simply amazed. They weren’t what he stereotypically thought of South Asian women, instead they were like typical Americans. They drank alcohol, watched wrestling, dated, traveled, etc. But this was short lived because they were just used as a prop to show how diverse his love life was. These dates were stuffed into one episode so Aziz’s character could return to being in love with his Italian friend Francesca. These brown women was just used to emphasize how much he belonged with Francesca.

Representation for South Asian women gets even worse in The Big Sick. Throughout the film Kumail’s mother would set him up with female suitors and every single one of them was used as comedic element. There was a sweet girl who decided to try to bond with Kumail over their mutual love of The X-Files, but instead of coming across as endearing, she is portrayed as creepy and cringy. There was another suitor shown who was listing all the types of bread products she couldn’t eat while Kumail looked miserable.
Just as in Master of None, these women were used as nothing but a prop to make Kumail’s girlfriend, Emily, look leaps and bounds better.

When he began to lose hope with these suitors, one emerged that tried to impress Kumail with a magic trick. He was impressed and interested enough to even linger on her headshot before he put her in the box of suitors headshots. Yet that was all dismissed because he was in love with his white girlfriend. He went out and said several times in the film that he couldn’t see himself marrying a Pakistani woman. Even though all of these women appeared to be very American in their interests and personalities, they weren’t good enough for his American life.

The biggest double standard in the film was when he questions the magic trick suitor’s desires to settle down, even though Emily had the same desires. It was acceptable for Emily to want to settle down, but not these brown women.
The biggest offence to the female South Asian characters, including non-suitors, was the forced “stereotypical” accents. Even his mother and sister-in-law had accents while Kumail did not even though he came to America when he was 14. One of the suitors was born in America and never left the country yet she still had an accent. The accent came off as symbol to show how backwards these South Asian women were compared to Kumail.

A counterpoint to all of this poor representation of South Asian women is the movie, Bend It Like Beckham. A film that featured a South Asian women who is in limbo trying to balance her modern British lifestyle with her parents’ Punjabi lifestyle. This movie was a more accurate portrayal of the struggle diaspora face. Her parents’ culture wasn’t made to look antiquated or backwards in order to make the British lifestyle look better.

South Asian lead shows and movies are becoming more common, but is it really representation for South Asian people? It’s been 15 years since Bend It Like Beckham and there has been no female South Asian led movie while there have been countless male leads. When these female characters do show up in movies or shows they are either used a punch line or as a prop to appease critics and meet some diversity criteria. So while South Asian males are getting their representation and stories being told, women are getting the brunt of the stick. How can we celebrate representation if it means brown women are being used as a joke?', 0, 0, false, false, '2017-07-15 12:47:14.694974+08', '2017-07-15 12:47:14.694974+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (8, 6, 6, 5, 'Glasshole 2.0', 'They’re still discussing how to handle tomorrow’s board meeting when it’s time to surrender their table to the next reservation. The bar has a huge library-themed back room where front-room evictees can mingle, so they adjourn to it. There, with plenty of smart, attractive women on hand, Mitchell’s like a kid in a candy store. A penniless, ravenous kid. One who can look all he wants, but that’s it. Or maybe “a meat-loving vegan at a cookout” maps better, because his hunger is principled, and self-imposed (and also, more primal than a grumpy sweet tooth). The thing is, Mitchell has essentially opted out of romance. It’s a long story. One we’ll get to at some point. And it’s all a weird, indirect response to his neural condition.', 0, 0, false, false, '2017-07-15 12:47:29.788922+08', '2017-07-15 12:47:29.788922+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (6, NULL, 6, 4, 'Glasshole 2.0', 'Heading toward the restroom, Mitchell considers Giftish.ly’s likely fate. Danna and Kuba personify the reason why God invented acquihires several years back. With every giant IPO minting a dozen new micro-VCs and hundreds of angels, almost any fool can raise a million bucks for a raw startup. Hence, countless fools do. Mitchell and Kuba are no fools — but they had no business raising a seed round with a casual snap of their fingers this early in their careers. Yet they did just that. As a direct result, Kuba left Google years before he would have otherwise, leaving Google down a great engineer. He pulled his two smartest colleagues along with him, so make that three great engineers. As for Danna, in a sane world she might have gone from Berkeley to a Google-like giant. But since we live in this world, why not launch your career at a crapshoot startup? If things pan out, you’re rich! And if not, you’ll get acquihired by an established company that can train and nurture you anyway. So for Danna and Kuba, a lame acquihire would be like camping out in front of a sold-out youth hostel on a postcollege, pre–Wall Street swing through Europe. Unpleasant, yes. But a great war story to preserve for the near future, when everyone’s graduated to comfy suites at The W.

Things are different for Mitchell. An acquihirer would have no use for a young MBA from a half-name school with a brief stint running a failed startup as his sole tech credential. And unlike his infinitely employable co-workers, he’d struggle to find a decent tech job elsewhere. This could mean his de facto expulsion from the industry that’s fascinated him since childhood. If only he could write great code, like Kuba! But years of trying showed he cannot. And no tech companies were seeking econ majors with 3.0 GPAs when he graduated from college. So he defaulted to a so-so Wall Street job, then later squeaked into a top-fifty-ish business school — after which the tech world still found him completely uninteresting. This might have been fine had he not gone and grown that brain of his. But falling under Kuba’s tutelage late in childhood had this effect, and Mitchell’s passion for tech is every bit as organic (even spiritual) as Kuba’s own.

After a brief wait, a mini-restroom opens, and Mitchell enters its private confines. Here, he considers the situation’s more menacing angle. Career thoughts aside, the deeper issue to him is their Animotion technology. No way would it survive an acquihire. Kuba’s tech team would be drawn and quartered, and assigned to whatever restaurant-seeking or photo-swapping feature their buyer is launching next. And Mitchell not only fervently believes in Animotion but may physically need for its research to continue! It’s because of the shit going wrong in his brain. The affliction that almost brought him to his knees outside the bar tonight. He’s just learned — bizarrely — that Animotion might shed some light on it and perhaps even point to a cure.

The attacks began in high school. They remained rare and mild for many years, seeming more like a novelty than a threat. Then, in his midtwenties, Mitchell developed a chilling intuition that there might be something truly awful behind them even though little had changed. This seemed to be confirmed a few years later, when the attacks escalated. He was festering in a lame digital marketing job at General Mills at the time. Years of shrugged clinical shoulders had shown he was undiagnosable to frontline doctors. So he turned to Facebook when things worsened, hoping to find a relevant expert within his extended circle. This reconnected him with Kuba’s UCSF bride, Ellie — a neuroscientist, and, like Kuba, a childhood friend. Though her own work was unconnected to Mitchell’s condition (or so it seemed at the time), Ellie referred 
him to a postdoc in her department who specializes in seizure syndromes.

And so, Mitchell entered the orbit of Dr. Martha Levine. One MRI led to another, and she was soon on a clinical crusade to get to the bottom of things. In San Francisco for an appointment with her, Mitchell caught up with Kuba for the first time since he vanished from the country. Nothing but radio silence had followed for a decade, which had perplexed and hurt Mitchell horribly. Reunited by the medical mystery, the years of separation disintegrated, and Mitchell finally learned that Kuba’s bizarre silence had been government-imposed. With that, all was understood (and forgiven). Next, they resumed an ancient conversation about starting a company together. Mitchell had already dreamt up his social gifting concept by then — and Kuba discerned a link between it and his wife’s research. And so they snapped their fingers and raised their seed capital. Mitchell moved to San Francisco, and it felt just like a storybook!

Until the worst day of his life. The day Dr. Martha diagnosed him.', 0, 1, false, false, '2017-07-15 12:46:26.295414+08', '2017-07-15 12:47:29.788922+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (9, 1, 1, 5, 'Aschenputtel', 'Es war ein armer Bauersmann, der saß abends beim Herd und schürte das Feuer, und die Frau saß und spann. Da sprach er "wie ists so traurig, daß wir keine Kinder haben! es ist so still bei uns, und in den andern Häusern ists so laut und lustig."

"Ja," antwortete die Frau und seufzte, "wenns nur ein einziges wäre, und wenns auch ganz klein wäre, nur Daumens groß, so wollte ich schon zufrieden sein; wir hättens doch von Herzen lieb."', 0, 0, true, false, '2017-07-15 12:47:44.465061+08', '2017-07-15 12:47:49.012147+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (11, 1, 1, 6, 'Aschenputtel', 'Nun geschah es, daß die Frau kränklich ward und nach sieben Monaten ein Kind gebar, das zwar an allen Gliedern vollkommen, aber nicht länger als ein Daumen war. Da sprachen sie "es ist, wie wir es gewünscht haben, und es soll unser liebes Kind sein," und nannten es nach seiner Gestalt Daumesdick. Sie ließens nicht an Nahrung fehlen, aber das Kind ward nicht größer, sondern blieb, wie es in der ersten Stunde gewesen war; doch schaute es verständig aus den Augen und zeigte sich bald als ein kluges und behendes Ding, dem alles glückte, was es anfing.', 0, 0, false, false, '2017-07-15 12:48:51.645057+08', '2017-07-15 12:48:51.645057+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (18, NULL, 12, 5, 'How I’m using Instagram Stories', 'I tend to watch all of my friends’ stories. I’ve never really cared for following personalities or brands on Instagram, but most of my friends do that, and they also check those stories.

I post videos and photos to my stories basically daily, and often 5 to 15 a day. You don’t worry too much about what you post: it expires, and if it’s bad you know that people can just flick through stories fast anyway. This gives incentive to create powerful content too: you know it has to be fun from the first second, and you know having some diversity makes people come back to your stories often.', 0, 2, false, false, '2017-07-15 12:53:08.339857+08', '2017-07-15 13:00:16.047178+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (12, NULL, 9, 7, 'Daumesdick', 'Es war ein armer Bauersmann, der saß abends beim Herd und schürte das Feuer, und die Frau saß und spann. Da sprach er "wie ists so traurig, daß wir keine Kinder haben! es ist so still bei uns, und in den andern Häusern ists so laut und lustig."

"Ja," antwortete die Frau und seufzte, "wenns nur ein einziges wäre, und wenns auch ganz klein wäre, nur Daumens groß, so wollte ich schon zufrieden sein; wir hättens doch von Herzen lieb."

Nun geschah es, daß die Frau kränklich ward und nach sieben Monaten ein Kind gebar, das zwar an allen Gliedern vollkommen, aber nicht länger als ein Daumen war. Da sprachen sie "es ist, wie wir es gewünscht haben, und es soll unser liebes Kind sein," und nannten es nach seiner Gestalt Daumesdick. Sie ließens nicht an Nahrung fehlen, aber das Kind ward nicht größer, sondern blieb, wie es in der ersten Stunde gewesen war; doch schaute es verständig aus den Augen und zeigte sich bald als ein kluges und behendes Ding, dem alles glückte, was es anfing.

Der Bauer machte sich eines Tages fertig, in den Wald zu gehen und Holz zu fällen, da sprach er so vor sich hin "nun wollt ich, daß einer da wäre, der mir den Wagen nachbrächte."

"O Vater," rief Daumesdick, "den Wagen will ich schon bringen, verlaßt Euch drauf, er soll zur bestimmten Zeit im Walde sein."

Da lachte der Mann und sprach "wie sollte das zugehen, du bist viel zu klein, um das Pferd mit dem Zügel zu leiten."

"Das tut nichts, Vater, wenn nur die Mutter anspannen will, ich setze mich dem Pferd ins Ohr und rufe ihm zu, wie es gehen soll."

"Nun," antwortete der Vater, "einmal wollen wirs versuchen."

Als die Stunde kam, spannte die Mutter an und setzte Daumesdick ins Ohr des Pferdes, und dann rief der Kleine, wie das Pferd gehen sollte, "jüh und joh! hott und har!" Da ging es ganz ordentlich als wie bei einem Meister, und der Wagen fuhr den rechten Weg nach dem Walde. Es trug sich zu, als er eben um eine Ecke bog und der Kleine "har, har!" rief, daß zwei fremde Männer daherkamen.

"Mein," sprach der eine, "was ist das? da fährt ein Wagen, und ein Fuhrmann ruft dem Pferde zu, und ist doch nicht zu sehen."

"Das geht nicht mit rechten Dingen zu," sagte der andere, "wir wollen dem Karren folgen und sehen, wo er anhält."

Der Wagen aber fuhr vollends in den Wald hinein und richtig zu dem Platze, wo das Holz gehauen ward. Als Daumesdick seinen Vater erblickte, rief er ihm zu "siehst du, Vater, da bin ich mit dem Wagen, nun hol mich runter." Der Vater faßte das Pferd mit der Linken und holte mit der Rechten sein Söhnlein aus dem Ohr, das sich ganz lustig auf einen Strohhalm niedersetzte. Als die beiden fremden Männer den Daumesdick erblickten, wußten sie nicht, was sie vor Verwunderung sagen sollten.

Da nahm der eine den andern beiseit und sprach "hör, der kleine Kerl könnte unser Glück machen, wenn wir ihn in einer großen Stadt für Geld sehen ließen, wir wollen ihn kaufen." Sie gingen zu dein Bauer und sprachen "verkauft uns den kleinen Mann" er solls gut bei uns haben."

"Nein," antwortete der Vater, "es ist mein Herzblatt, und ist mir für alles Gold in der Welt nicht feil!"

Daumesdick aber, als er von dem Handel gehört, war an den Rockfalten seines Vaters hinaufgekrochen, stellte sich ihm auf die Schulter und wisperte ihm ins Ohr "Vater, gib mich nur hin, ich will schon wieder zurückkommen."

Da gab ihn der Vater für ein schönes Stück Geld den beiden Männern hin. "Wo willst du sitzen?, sprachen sie zu ihm.

"Ach, setzt mich nur auf den Rand von eurem Hut, da kann ich auf und ab spazieren und die Gegend betrachten, und falle doch nicht herunter." Sie taten ihm den Willen, und als Daumesdick Abschied von seinem Vater genommen hatte, machten sie sich mit ihm fort. So gingen sie, bis es dämmrig ward, da sprach der Kleine "hebt mich einmal herunter, es ist nötig."

"Bleib nur droben" sprach der Mann, auf dessen Kopf er saß, "ich will mir nichts draus machen, die Vögel lassen mir auch manchmal was drauf fallen."

"Nein," sprach Daumesdick, "ich weiß auch, was sich schickt, hebt mich nur geschwind herab."

Der Mann nahm den Hut ab und setzte den Kleinen auf einen Acker am Weg, da sprang und kroch er ein wenig zwischen den Schollen hin und her, dann schlüpfte er pIötzlich in ein Mausloch, das er sich ausgesucht hatte. "Guten Abend, ihr Herren, geht nur ohne mich heim," rief er ihnen zu, und lachte sie aus. Sie liefen herbei und stachen mit Stöcken in das Mausloch, aber das war vergebliche Mühe, Daumesdick kroch immer weiter zurück, und da es bald ganz dunkel ward, so mußten sie mit Ärger und mit leerem Beutel wieder heim wandern.

Als Daumesdick merkte, daß sie fort waren, kroch er aus dem unterirdischen Gang wieder hervor. "Es ist auf dem Acker in der Finsternis so gefährlich gehen," sprach er, "wie leicht bricht einer Hals und Bein." Zum Glück stieß er an ein leeres Schneckenhaus. "Gottlob," sagte er, "da kann ich die Nacht sicher zubringen," und setzte sich hinein.

Nicht lang, als er eben einschlafen wollte, so hörte er zwei Männer vorübergehen, davon sprach der eine "wie wirs nur anfangen, um dem reichen Pfarrer sein Geld und sein Silber zu holen?,

"Das könnt ich dir sagen," rief Daumesdick dazwischen.

"Was war das?" sprach der eine Dieb erschrocken, "ich hörte jemand sprechen."

Sie blieben stehen und horchten, da sprach Daumesdick wieder "nehmt mich mit, so will ich euch helfen."

"Wo bist du denn?"

"Sucht nur auf der Erde und merkt, wo die Stimme herkommt," antwortete er.

Da fanden ihn endlich die Diebe und hoben ihn in die Höhe. "Du kleiner Wicht, was willst du uns helfen!" sprachen sie.

"Seht," antwortete er, "ich krieche zwischen den Eisenstäben in die Kammer des Pfarrers und reiche euch heraus, was ihr haben wollt."

"Wohlan," sagten sie, "wir wollen sehen, was du kannst."

Als sie bei dem Pfarrhaus kamen, kroch Daumesdick in die Kammer, schrie aber gleich aus Leibeskräften "wollt ihr alles haben, was hier ist?"

Die Diebe erschraken und sagten "so sprich doch leise, damit niemand aufwacht."

Aber Daumesdick tat, als hätte er sie nicht verstanden, und schrie von neuem "Was wollt ihr? Wollt ihr alles haben, was hier ist?"

Das hörte die Köchin, die in der Stube daran schlief, richtete sich im Bete auf und horchte. Die Diebe aber waren vor Schrecken ein Stück Wegs zurückgelaufen, endlich faßten sie wieder Mut und dachten "der kleine Kerl will uns necken." Sie kamen zurück und flüsterten ihm zu "nun mach Ernst und reich uns etwas heraus."

Da schrie Daumesdick noch einmal, so laut er konnte "ich will euch ja alles geben, reicht nur die Hände herein."

Das hörte die horchende Magd ganz deutlich, sprang aus dem Bett und stolperte zur Tür herein. Die Diebe liefen fort und rannten, als wäre der wilde Jäger hinter ihnen; die Magd aber, als sie nichts bemerken konnte, ging ein Licht anzünden. Wie sie damit herbeikam, machte sich Daumesdick, ohne daß er gesehen wurde, hinaus in die Scheune: die Magd aber, nachdem sie alle Winkel durchgesucht und nichts gefunden hatte, legte sich endlich wieder zu Bett und glaubte, sie hätte mit offenen Augen und Ohren doch nur geträumt.

Daumesdick war in den Heuhälmchen herumgeklettert und hatte einen schönen Platz zum Schlafen gefunden: da wollte er sich ausruhen, bis es Tag wäre, und dann zu seinen Eltern wieder heimgehen. Aber er mußte andere Dinge erfahren! ja, es gibt viel Trübsal und Not auf der Welt! Die Magd stieg, als der Tag graute, schon aus dem Bett, um das Vieh zu füttern. Ihr erster Gang war in die Scheune, wo sie einen Arm voll Heu packte, und gerade dasjenige, worin der arme Daumesdick. lag und schlief. Er schlief aber so fest, daß er nichts gewahr ward, und nicht eher aufwachte, als bis er in dem Maul der Kuh war, die ihn mit dem Heu aufgerafft hatte.

"Ach Gott," rief er, "wie bin ich in die Walkmühle geraten!" merkte aber bald, wo er war. Da hieß es aufpassen, daß er nicht zwischen die Zähne kam und zermalmt ward, und hernach mußte er doch mit in den Magen hinabrutschen. "In dem Stübchen sind die Fenster vergessen," sprach er, "und scheint keine Sonne hinein: ein Licht wird auch nicht gebracht."

Überhaupt gefiel ihm das Quartier schlecht, und was das Schlimmste war, es kam immer mehr neues Heu zur Türe hinein, und der Platz ward immer enger. Da rief er endlich in der Angst, so laut er konnte, "Bringt mir kein frisch Futter mehr, bringt mir kein frisch Futter mehr."

Die Magd melkte gerade die Kuh, und als sie sprechen hörte, ohne jemand zu sehen, und es dieselbe Stimme war, die sie auch in der Nacht gehört hatte, erschrak sie so, daß sie von ihrem Stühlchen herabglitschte und die Milch verschüttete.

Sie lief in der größten Hast zu ihrem Herrn und rief "Ach Gott, Herr Pfarrer, die Kuh hat geredet."

"Du bist verrückt," antwortete der Pfarrer, ging aber doch selbst in den Stall und wollte nachsehen, was es da gäbe. Kaum aber hatte er den Fuß hineingesetzt, so rief Daumesdick aufs neue "Bringt mir kein frisch Futter mehr, bringt mir kein frisch Futter mehr."

Da erschrak der Pfarrer selbst, meinte, es wäre ein böser Geist in die Kuh gefahren, und hieß sie töten. Sie ward geschlachtet, der Magen aber, worin Daumesdick steckte, auf den Mist geworfen. Daumesdick hatte große Mühe, sich hindurchzuarbeiten, und hatte große Mühe damit, doch brachte ers so weit, daß er Platz bekam, aber als er eben sein Haupt herausstrecken wollte, kam ein neues Unglück. Ein hungriger Wolf lief heran und verschlang den ganzen Magen mit einem Schluck. 2

Daumnesdick verlor den Mut nicht, "vielleicht," dachte er, "läßt der Wolf mit sich reden," und rief ihm aus dem Wanste zu "lieber Wolf" ich weiß dir einen herrlichen Fraß."

"Wo ist der zu holen?" sprach der Wolf.

"In dem und dem Haus, da mußt du durch die Gosse hineinkriechen, und wirst Kuchen, Speck und Wurst finden, so viel du essen willst," und beschrieb ihm genau seines Vaters Haus.

Der Wolf ließ sich das nicht zweimal sagen, drängte sich in der Nacht zur Gosse hinein und fraß in der Vorratskammer nach Herzenslust. Als er sich gesättigt hatte" wollte er wieder fort, aber er war so dick geworden" daß er denselben Weg nicht wieder hinaus konnte. Darauf hatte Daumesdick gerechnet und fing nun an" in dem Leib des Wolfes einen gewaltigen Lärmen zu machen, tobte und schrie, was er konnte.

"Willst du stille sein," sprach der Wolf, "du weckst die Leute auf."

"Ei was," antwortete der Kleine, "du hast dich satt gefressen, ich will mich auch lustig machen," und fing von neuem an, aus allen Kräften zu schreien.

Davon erwachte endlich sein Vater und seine Mutter, liefen an die Kammer und schauten durch die Spalte hinein. Wie sie sahen, daß ein Wolf darin hauste, liefen sie davon, und der Mann holte eine Axt, und die Frau die Sense.

"Bleib dahinten," sprach der Mann, als sie in die Kammer traten, "wenn ich ihm einen Schlag gegeben habe, und er davon noch nicht tot ist, so mußt du auf ihn einhauen, und ihm den Leib zerschneiden."

Da hörte Daumesdick die Stimme seines Vaters und rief "lieber Vater, ich bin hier, ich stecke im Leibe des Wolfs."

Sprach der Vater voll Freuden "Gottlob, unser liebes Kind hat sich wiedergefunden," und hieß die Frau die Sense wegtun, damit Daumesdick nicht beschädigt würde. Danach holte er aus, und schlug dem Wolf einen Schlag auf den Kopf, daß er tot niederstürzte, dann suchten sie Messer und Schere, schnitten ihm den Leib auf und zogen den Kleinen wieder hervor.

"Ach," sprach der Vater, "was haben wir für Sorge um dich ausgestanden!,

"Ja, Vater, ich bin viel in der Welt herumgekommen; gottlob, daß ich wieder frische Luft schöpfe!"

"Wo bist du denn all gewesen?"

"Ach, Vater, ich war in einem Mauseloch, in einer Kuh Bauch und in eines Wolfes Wanst: nun bleib ich bei euch."

"Und wir verkaufen dich um alle Reichtümer der Welt nicht wieder," sprachen die Eltern, herzten und küßten ihren lieben Daumesdick. Sie gaben ihm zu essen und trinken, und ließen ihm neue Kleider machen, denn die seinigen waren ihm auf der Reise verdorben.', 0, 0, false, false, '2017-07-15 12:49:20.228497+08', '2017-07-15 12:49:20.228497+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (14, 13, 10, 4, 'Dornröschen', 'Dar wöör maal eens en Fischer un syne Fru, de waanden tosamen in''n Pißputt, dicht an der See, un de Fischer güng alle Dage hen un angeld: un he angeld un angeld. So seet he ook eens by de Angel und seeg jümmer in das blanke Water henin: un he seet un seet. Do güng de Angel to Grund, deep ünner, un as he se herup haald, so haald he enen grooten Butt heruut.

Do säd de Butt to em "hör mal, Fischer, ik bidd dy, laat my lewen, ik bün keen rechten Butt, ik bün''n verwünschten Prins. Wat helpt dy dat, dat du my doot maakst? i würr dy doch nich recht smecken: sett my wedder in dat Water un laat my swemmen."', 0, 0, false, false, '2017-07-15 12:50:09.707371+08', '2017-07-15 12:50:09.707371+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (13, NULL, 10, 8, 'Dornröschen', 'Vor Zeiten war ein König und eine Königin, die sprachen jeden Tag: "Ach, wenn wir doch ein Kind hätten!" und kriegten immer keins.
Da trug es sich zu, als die Königin einmal im Bade saß, daß ein Frosch aus dem Wasser ans Land kroch und zu ihr sprach: "Dein Wunsch wird erfüllt werden, ehe ein Jahr vergeht, wirst du eine Tochter zur Welt bringen."

Was der Frosch gesagt hatte, das geschah, und die Königin gebar ein Mädchen, das war so schön, daß der König vor Freude sich nicht zu fassen wußte und ein großes Fest anstellte. Er ladete nicht bloß seine Verwandten, Freunde und Bekannten, sondern auch die weisen Frauen dazu ein, damit sie dem Kind hold und gewogen wären. Es waren ihrer dreizehn in seinem Reiche, weil er aber nur zwölf goldene Teller hatte, von welchen sie essen sollten, so mußte eine von ihnen daheim bleiben.

Das Fest ward mit aller Pracht gefeiert, und als es zu Ende war, beschenkten die weisen Frauen das Kind mit ihren Wundergaben: die eine mit Tugend, die andere mit Schönheit, die dritte mit Reichtum und so mit allem, was auf der Welt zu wünschen ist. Als elfe ihre Sprüche eben getan hatten, trat plötzlich die dreizehnte herein.

Sie wollte sich dafür rächen, daß sie nicht eingeladen war, und ohne jemand zu grüßen oder nur anzusehen, rief sie mit lauter Stimme: "Die Königstochter soll sich in ihrem fünfzehnten Jahr an einer Spindel stechen und tot hinfallen." Und ohne ein Wort weiter zu sprechen kehrte sie sich um und verließ den Saal.

Alle waren erschrocken, da trat die zwölfte hervor, die ihren Wunsch noch übrig hatte, und weil sie den bösen Spruch nicht aufheben, sondern ihn nur mildern konnte, so sagte sie: "Es soll aber kein Tod sein, sondern ein hundertjähriger tiefer Schlaf, in welchen die Königstochter fällt.

Der König, der sein liebes Kind vor dem Unglück gern bewahren wollte, ließ den Befehl ausgehen, daß alle Spindeln im ganzen Königreiche sollten verbrannt werden. An dem Mädchen aber wurden die Gaben der weisen Frauen sämtlich erfüllt, denn es war so schön, sittsam, freundlich und verständig daß es jedermann, der es ansah, liebhaben mußte. Es geschah, daß an dem Tage, wo es gerade fünfzehn Jahre alt ward, der König und die Königin nicht zu Haus waren und das Mädchen ganz allein im Schloß zurückblieb. Da ging es allerorten herum, besah Stuben und Kammern, wie es Lust hatte, und kam endlich auch an einen alten Turm. Es stieg die enge Wendeltreppe hinauf und gelangte zu einer kleinen Türe. In dem Schloß steckte ein verrosteter Schlüssel, und als es ihn umdrehte, sprang die Türe auf, und da saß in einem kleinen Stübchen eine alte Frau mit einer Spindel und spann emsig ihren Flachs.

"Guten Tag, du altes Mütterchen", sprach die Königstochter, "was machst du da?"

"Ich spinne", sagte die Alte und nickte mit dem Kopf.

"Was ist das für ein Ding, das so lustig herumspringt?" sprach das Mädchen, nahm die Spindel und wollte auch spinnen. Kaum hatte sie aber die Spindel angerührt so ging der Zauberspruch in Erfüllung, und sie stach sich damit in den Finger.

In dem Augenblick aber, wo sie den Stich empfand, fiel sie auf das Bett nieder, das da stand, und lag in einem tiefen Schlaf. Und dieser Schlaf verbreitete sich über das ganze Schloß, der König und die Königin, die eben heimgekommen waren und in den Saal getreten waren, fingen an einzuschlafen und der ganze Hofstaat mit ihnen. Da schliefen auch die Pferde im Stall, die Hunde im Hof, die Tauben auf dem Dache, die Fliegen an der Wand, ja, das Feuer, das auf dem Herde flackerte, ward still und schlief ein, und der Braten hörte auf zu brutzeln, und der Koch, der den Küchenjungen, weil er etwas versehen hatte, an den Haaren ziehen wollte, ließ ihn los und schlief. Und der Wind legte sich, und auf den Bäumen vor dem Schloß regte sich kein Blättchen mehr.

Rings um das Schloß aber begann eine Dornenhecke zu wachsen, die jedes Jahr höher ward und endlich das ganze Schloß umzog und darüber hinauswuchs, daß gar nichts mehr davon zu sehen war, selbst nicht die Fahne auf dem Dach. Es ging aber die Sage in dem Land von dem schönen, schlafenden Dornröschen, denn so ward die Königstochter genannt, also daß von Zeit zu Zeit Königssöhne kamen und durch die Hecke in das Schloß dringen wollten. Es war ihnen aber nicht möglich, denn die Dornen, als hätten sie Hände, hielten fest zusammen, und die Jünglinge blieben darin hängen, konnten sich nicht wieder losmachen und starben eines jämmerlichen Todes.

Nach langen, langen Jahren kam wieder einmal ein Königssohn in das Land und hörte, wie ein alter Mann von der Dornenhecke erzählte, es sollte ein Schloß dahinter stehen, in welchem eine wunderschöne Königstochter, Dornröschen genannt, schon seit hundert Jahren schliefe, und mit ihr schliefe der König und die Königin und der ganze Hofstaat. Er wußte auch von seinem Großvater, daß schon viele Königssöhne gekommen wären und versucht hätten, durch die Dornenhecke zu dringen, aber sie wären darin hängengeblieben und eines traurigen Todes gestorben.

Da sprach der Jüngling: "Ich fürchte mich nicht, ich will hinaus und das schöne Dornröschen sehen !" Der gute Alte mochte ihm abraten, wie er wollte, er hörte nicht auf seine Worte.

Nun waren aber gerade die hundert Jahre verflossen, und der Tag war gekommen, wo Dornröschen wieder erwachen sollte. Als der Königssohn sich der Dornenhecke näherte, waren es lauter große, schöne Blumen, die taten sich von selbst auseinander und ließen ihn unbeschädigt hindurch, und hinter ihm taten sie sich wieder als eine Hecke zusammen. Im Schloßhof sah er die Pferde und scheckigen Jagdhunde liegen und schlafen, auf dem Dache saßen die Tauben und hatten das Köpfchen unter den Flügel gesteckt. Und als er ins Haus kam, schliefen die Fliegen an der Wand, der Koch in der Küche hielt noch die Hand, als wollte er den Jungen anpacken, und die Magd saß vor dem schwarzen Huhn, das sollte gerupft werden.

Da ging er weiter und sah im Saale den ganzen Hofstaat liegen und schlafen, und oben bei dem Throne lagen der König und die Königin.

Da ging er noch weiter, und alles war so still, daß er seinen Atem hören konnte, und endlich kam er zu dem Turm und öffnete die Türe zu der kleinen Stube, in welcher Dornröschen schlief.

Da lag es und war so schön, daß er die Augen nicht abwenden konnte, und er bückte sich und gab ihm einen Kuß. Wie er es mit dem Kuß berührt hatte, schlug Dornröschen die Augen auf, erwachte und blickte ihn ganz freundlich an.

Da gingen sie zusammen herab, und der König erwachte und die Königin und der ganze Hofstaat und sahen einander mit großen Augen an. Und die Pferde im Hof standen auf und rüttelten sich, die Jagdhunde sprangen und wedelten, die Tauben auf dem Dache zogen das Köpfchen unterm Flügel hervor, sahen umher und flogen ins Feld, die Fliegen an den Wänden krochen weiter, das Feuer in der Küche erhob sich, flackerte und kochte das Essen, der Braten fing wieder an zu brutzeln, und der Koch gab dem Jungen eine Ohrfeige, daß er schrie, und die Magd rupfte das Huhn fertig.

Und da wurde die Hochzeit des Königssohns mit dem Dornröschen in aller Pracht gefeiert, und sie lebten vergnügt bis an ihr Ende. ', 0, 1, false, false, '2017-07-15 12:49:49.076882+08', '2017-07-15 12:50:09.707371+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (15, 10, 8, 4, 'Can you make a movie about eating disorders without glamorizing them?', 'The top row on Instagram excites me. I check Instagram more often & only bother scrolling down the feed once a day, if I don’t forget.

', 0, 0, false, false, '2017-07-15 12:50:24.742072+08', '2017-07-15 12:50:24.742072+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (10, NULL, 8, 6, 'Can you make a movie about eating disorders without glamorizing them?', 'Adapted from a story by The Washington Post’s Bethonie Butler.

Part drama, part dark comedy, Netflix’s “To the Bone” stars Lily Collins as Ellen, a young woman who, after multiple stays in inpatient treatment programs, grudgingly agrees to live in a group home run by an unconventional doctor.
Netflix posted the trailer on June 20, prompting an intense Twitter debate around whether the film glamorizes anorexia nervosa and whether it could be harmful or a trigger for those with eating disorders. (Anorexia has the highest mortality rate of any mental illness, according to the National Institute of Mental Health.)

The trailer shows elements of the film — Ellen ticking off calorie counts for the items on her dinner plate, a close-up of her extremely thin frame — that highlight the challenge of portraying eating disorders on-screen in a responsible way.
Critics of the trailer have zeroed in on the film’s protagonist: a young, thin, white woman with anorexia, a prevailing narrative in pop culture despite the fact that eating disorders vary and affect people of all backgrounds.
“It reinforces stereotypes about what an eating disorder is and looks like,” one survivor told Teen Vogue. “That imagery is everywhere, and it is actually celebrated in our culture.”', 0, 1, false, false, '2017-07-15 12:48:41.408999+08', '2017-07-15 12:50:24.742072+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (17, 16, 11, 3, 'I’m a millennial and I share more music through Instagram Stories than any other medium', '__How Instagram became fun again__

Facebook, which owns Instagram, tried to buy Snapchat, but their offer was declined. I guess the Silicon Valley version of “if you can’t beat them, join them” goes:

> “If they won’t join you, copy them.”

So that’s what they did.', 0, 0, false, false, '2017-07-15 12:52:07.528182+08', '2017-07-15 12:52:07.528182+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (16, NULL, 11, 4, 'I’m a millennial and I share more music through Instagram Stories than any other medium', 'I’ve previously explained how Instagram’s Snapchat-cloned Stories functionality represents a great marketing opportunity for artists. Now I want to signify its broader importance to music, and social media in general.

## Instagram’s top row containing stories

⚠️ You should be paying a lot of attention to Instagram Stories
Remember Facebook back in 2007–2010? Back when people were still posting Facebook updates in third person?

2008-style third person Facebook status update

Back then, Facebook was so compelling to just post stuff to. It was useful and fun, despite having to write status updates in third person being kind of awkward.

People would post a lot. Interaction would be high. Much of what people were posting was public. Then everyone’s family started to join. Random people from different moments in your life started adding each other. And more recently I’ve been getting more friend requests from people I know professionally than LinkedIn invites.

## Facebook is not fun anymore.

Facebook is useful, but it’s not fun. People are more careful about what they choose to post. And now, people who have been using the internet since the 90s are reaching retirement age. Your family is going to be on Facebook all day; watching you.

Just posting quick thoughts on Facebook makes no sense anyway. My Facebook used to be full of “anyone want to grab a drink tonight?” but now you can’t be sure if that message even gets seen by friends. Facebook is not a timely medium anymore. If you want to do ‘spontaneous drinks’ with random friends, you better post a status update 2 days in advance.

## Instagram used to be fun

The thing people used to say about Instagram, was that that’s where all the young people fled as their parents and other relatives started using Facebook. It was fun, because it was actually instant: you had a sense of what friends were up to. The filters made it easy to make decent photos and have them look ok, or artsy, or whatever.

But over time, people grew aware once more that what they post is there to stay, started feeling self-conscious, and a lot of the fun faded.

## Fun is why people create

When people are having fun they interact, they dance, they talk, they laugh, they share, they kiss, and they open up. This is why Facebook was so good: people were mindlessly posting things because it was fun. Then they became self-conscious. This is why Instagram was so good, but then people became self-conscious. And this is what Snapchat absolutely nailed with their ephemeral content.

I doubt Snapchat invented the idea, but their timing of launching an app where users can share moments that expire every 24 hours was perfect. Their augmented reality filters gave people a way to keep sharing, to keep creating, even when they were uninspired. Super fun.', 0, 1, false, false, '2017-07-15 12:51:28.26333+08', '2017-07-15 12:52:07.528182+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (19, NULL, 13, 7, 'The Lost Art of Quitting', 'I was making more money than I ever had before. I finally had the job I had worked so long and so hard to get. Life was perfect, right?
Well, there was just one problem: I hated it.
I was stressed all the time. I was working 12+ hours per day, 7 days per week. I wasn’t getting nearly enough sleep. It was a struggle to get out of bed every morning. I was forcing myself to do stuff I hated doing almost every second of every day. I barely had any time for the things that are most important to me.
My rock bottom moment was when my girlfriend lost her job. As you can probably imagine, she was very upset and worried, and I wanted to be there to console her and encourage her to bounce back.
Instead, I worked until 10pm that night. She went out with her friends because I couldn’t be there with her.
When I finally got home late that night, I realized I didn’t care about the extra money as much as I cared about my relationship…and my own sanity. I decided it was time for me to make a change.', 0, 0, false, false, '2017-07-15 12:53:45.167717+08', '2017-07-15 12:53:45.167717+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (20, 18, 12, 7, 'How I’m using Instagram Stories', 'When I told my friend that I was thinking of leaving the job, he tried to convince me otherwise. “Suck it up, bro. Don’t be a quitter”, he said.
That label, “quitter,” made me think. I didn’t want to be one of “those people.” I identified as someone who perseveres, regardless of the road blocks. But my desire to quit didn’t fully subside.', 0, 0, false, false, '2017-07-15 12:53:57.142497+08', '2017-07-15 12:53:57.142497+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (21, 1, 1, 7, 'Aschenputtel', 'Labels, such as “quitter,” hinder us from considering nuance or rationale. Rather, they’re blanket, binary descriptions that shame us into avoiding association.
In the case of quitting, there are often good reasons to persevere and not quit. You don’t want to leave someone hanging after you’ve made a commitment. And there may be potential to improve the situation over time if you put in the work. Those are both perfectly good reasons and they must be considered. However, they also must be balanced with your own needs and consideration for what’s actually achievable.', 0, 0, false, false, '2017-07-15 12:54:07.687433+08', '2017-07-15 12:54:07.687433+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (1, NULL, 1, 1, 'Aschenputtel', 'Einem reichen Manne, dem wurde seine Frau krank, und als sie fühlte, daß ihr Ende herankam, rief sie ihr einziges Töchterlein zu sich ans Bett und sprach "liebes Kind, bleibe fromm und gut, so wird dir der liebe Gott immer beistehen, und ich will vom Himmel auf dich herabblicken, und will um dich sein."

Darauf tat sie die Augen zu und verschied. Das Mädchen ging jeden Tag hinaus zu dem Grabe der Mutter und weinte, und blieb fromm und gut. Als der Winter kam, deckte der Schnee ein weißes Tüchlein auf das Grab, und als die Sonne im Frühjahr es wieder herabgezogen hatte, nahm sich der Mann eine andere Frau.

Die Frau hatte zwei Töchter mit ins Haus gebracht, die schön und weiß von Angesicht waren, aber garstig und schwarz von Herzen. Da ging eine schlimme Zeit für das arme Stiefkind an. "Soll die dumme Gans bei uns in der Stube sitzen", sprachen sie, "wer Brot essen will, muß es verdienen: hinaus mit der Küchenmagd." Sie nahmen ihm seine schönen Kleider weg, zogen ihm einen grauen alten Kittel an, und gaben ihm hölzerne Schuhe.

"Seht einmal die stolze Prinzessin, wie sie geputzt ist", riefen sie, lachten und führten es in die Küche. Da mußte es von Morgen bis Abend schwere Arbeit tun, früh vor Tag aufstehn, Wasser tragen, Feuer anmachen, kochen und waschen. Obendrein taten ihm die Schwestern alles ersinnliche Herzeleid an, verspotteten es und schütteten ihm die Erbsen und Linsen in die Asche, so daß es sitzen und sie wieder auslesen mußte. Abends, wenn es sich müde gearbeitet hatte, kam es in kein Bett, sondern mußte sich neben den Herd in die Asche legen. Und weil es darum immer staubig und schmutzig aussah, nannten sie es Aschenputtel.

Es trug sich zu, daß der Vater einmal in die Messe ziehen wollte, da fragte er die beiden Stieftöchter, was er ihnen mitbringen sollte. 

"Schöne Kleider" sagte die eine, "Perlen und Edelsteine" die zweite. 

"Aber du, Aschenputtel" sprach er, "was willst du haben?" ', 0, 3, false, false, '2017-07-15 12:39:45.738283+08', '2017-07-15 12:54:07.687433+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (23, 22, 14, 8, 'Did steam eat the world?', 'They were! Steam was a massive concept. Google has a great way to research the question. It’s called Ngrams and it counts the appearance of terms in publications going back hundreds of years. If someone was chatting about steam[fill in the blank] in a newspaper or book, we could find the relative frequency of that term. We’re talking about digging up 200-year old, tech-crowd chatter.', 0, 0, false, false, '2017-07-15 12:55:08.876836+08', '2017-07-15 12:55:08.876836+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (22, NULL, 14, 6, 'Did steam eat the world?', 'Marc Andreessen is famous for coining the phrase “software is eating the world.” The point: firms of all shapes and sizes are using technology to transform their business model and products. What people remembered? “Disruption is coming” “Uncertainty is everywhere” “Digital experiences are king.”
The buzz hasn’t stopped. Incumbent firms are acquiring start-ups at an astonishing rate and investing millions into “innovation labs.” The payoffs have been hit or miss.
Has it always been this way? Have previous generations hyped general technology? I was recently in Seattle, WA and walked past their beautiful Amtrak station. It prompted question: were people this psyched about steam?
', 0, 2, false, false, '2017-07-15 12:54:56.779554+08', '2017-07-15 12:59:29.606621+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (26, NULL, 17, 5, 'Ancient Transatlantic Misadventure', 'Around forty million years ago, a rather large group of Old World monkeys were out foraging for mangroves off the coast of Africa. Then, a violent storm came and suddenly dislodged a huge portion of the vegetation, taking them along with it. As a consequence of this, they were dragged out to sea from the mouth of the Niger River, and the small marmoset-like animals were set adrift. So, they quickly lost sight of land, and feelings of desperation set in.
Fortunately for those cute little simian rascals, at the time of their departure the Isthmus of Panama had not yet formed, and the climate was much different than it is now. This had a significant impact on the ocean currents then, making them far more favorable to the bewildered migrants, although they had no way of knowing it. However, the Atlantic was still only about two-thirds the width that it is now, so the monkeys didn’t have nearly as far to go to get where they needed to be.
Regardless, as the prehistoric primates drifted along for weeks on end, the isolated group of potential breeding pairs gradually died off more and more. As they battled against dehydration, starvation, and lethal sun exposure, it became increasingly more unlikely that the monkeys would ever make it to land in time for any of them to actually survive. Nonetheless, against all odds, the rafting event finally resulted in a successful oceanic dispersion. The brittle storm-tossed watercraft ultimately washed ashore, after successfully ferrying those soggy pioneers hundreds of miles across the globe.
So, having made it to the lush Amazon Basin all the way form the Gulf of Guinea, the New World monkeys evolved into multiple different forms and spread as far north as the Caribbean and as far south as Patagonia. As a result of their death-defying journey form one continent to another, there are now more than a hundred different primate species native to the Americas, including woolly monkeys, night monkeys, spider monkeys, howler monkeys, squirrel monkeys and so much more. What a bizarre transatlantic misadventure they must have had.', 0, 0, false, false, '2017-07-15 12:57:38.481541+08', '2017-07-15 12:57:38.481541+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (24, NULL, 15, 7, 'Von dem Fischer un syner Fru', 'Dar wöör maal eens en Fischer un syne Fru, de waanden tosamen in''n Pißputt, dicht an der See, un de Fischer güng alle Dage hen un angeld: un he angeld un angeld. So seet he ook eens by de Angel und seeg jümmer in das blanke Water henin: un he seet un seet. Do güng de Angel to Grund, deep ünner, un as he se herup haald, so haald he enen grooten Butt heruut.

Do säd de Butt to em "hör mal, Fischer, ik bidd dy, laat my lewen, ik bün keen rechten Butt, ik bün''n verwünschten Prins. Wat helpt dy dat, dat du my doot maakst? i würr dy doch nich recht smecken: sett my wedder in dat Water un laat my swemmen."

"Nu," säd de Mann, "du bruukst nich so veel Wöörd to maken, eenen Butt, de spreken kann, hadd ik doch wol swemmen laten."

Mit des sett"t he em wedder in dat blanke Water, do güng de Butt to Grund und leet enen langen Strypen Bloot achter sik. So stünn de Fischer up un güng nach syne Fru in''n Pißputt.

"Mann," säd de Fru, "hest du hüüt niks fungen?"

"Ne," säd de Mann, "ik füng enen Butt, de säd, he wöör en verwünschten Prins, da hebb ik em wedder swemmen laten."

"Hest du dy denn niks wünschd?" söd de Fru.

"Ne," säd de Mann, "wat schull ik my wünschen?"

"Ach," säd de Fru, "dat is doch äwel, hyr man jümmer in''n Pißputt to waanen, dat stinkt un is so eeklig: du haddst uns doch ene lüttje Hütt wünschen kunnt. Ga noch hen un roop em: segg em, wy wählt ''ne lüttje Hütt hebben, he dait dat gewiß."

"Ach," säd de Mann, "wat schull ich door noch hengaan?"

"I," säd de Fru, "du haddst em doch fungen, un hest em wedder swemmen laten, he dait dat gewiß. Ga glyk hen."

De Mann wull noch nicht recht, wull awerst syn Fru ook nicht to weddern syn un güng hen na der See. As he door köhm, wöör de See ganß gröon un geel un goor nich mee so blank. So güng he staan und säd

"Manntje, Manntje, Timpe Te, 
Buttje, Buttje in der See, 
Myne Fru, de Ilsebill 
Will nich so, as ik wol will."
Do köhm de Butt answemmen un säd "na, wat will se denn?"

"Ach," säd de Mann, "ik hebb di doch fungen hatt, nu säd myn Fru, ik hadd my doch wat wünschen schullt. Se mag nich meer in''n Pißputt wanen, se wull geern ''ne Hütt."

"Ga man hen," säd de Butt, "se hett se all."

Do güng de Mann hen, un syne Fru seet nich meer in''n Piß putt, dar stünn awerst ene lüttje Hütt, un syne Fru seet vor de Döhr up ene Bänk. Da nöhm syne Fru em by de Hand un säd to em "kumm man herin, süh, nu is dar doch veel beter."

Do güngen se henin, un in de Hütt was een lüttjen VörpIatz un ene lüttje herrliche Stuw un Kamer, wo jem eer Beed stünn, un Kääk un Spysekamer, allens up dat beste mit Gerädschop pen, un up dat schönnste upgefleyt, Tinntüüg un Mischen, wat sik darin höört. Un achter was ook en lüttjen Hof mit Hönern un Aanten, un en lüttjen Goorn mit Grönigkeiten un Aaft.

"Süh," säd de Fru, "is dat nich nett?"

"Ja," säd de Mann, "so schall"t blywen, nu wähl wy recht vergnöögt lewen."

"Dat wähl wy uns bedenken," säd de Fru. Mit des eeten se wat un güngen to Bedd.

So güng dat wol ''n acht oder veertein Dag, do säd de Fru "hör, Mann, de Hütt is ook goor to eng, un de Hof un de Goorn is so kleen: de Butt hadd uns ook wol een grötter Huus schenken kunnt. Ich much woll in enem grooten stenern Slott wanen: ga hen tom Butt, he schall uns en Slott schenken."

"Ach, Fru," säd de Mann, "de Hütt is jo god noog, wat wähl wy in''n Slott wanen."

"I wat," säd de Fru, "ga du man hen, de Butt kann dat jümmer doon."

"Ne, Fru," säd de Mann, "de Butt hett uns eerst de Hütt gewen, ik mag nu nich all wedder kamen, den Butt muchd et vördreten."

"Ga doch," säd de Fru, "he kann dat recht good und dait dat geern; ga du man hen."

Dem Mann wöör syn Hart so swoor, un wull nich; he säd by sik sülwen "dat is nich recht," he güng awerst doch hen. As he an de See köhm, wöör dat Water ganß vigelett un dunkelblau un grau un dick, un goor nich meer so gröön un geel, doch wöör"t noch still. Do güng he staan un säd

"Manntje, Manntje, Timpe Te,
Buttje, Buttje in der See,
Myne Fru, de Ilsebill,
Will nich so, as ik wol will."
"Na wat will se denn?" säd de Butt.

"Ach," säd de Mann half bedrööft, "se will in''n groot stenern Slott wanen."

"Ga man hen, se stait vör der Döhr," säd de Butt.

Da güng de Mann hen un dachd, he wull na Huus gaan, as he awerst daar köhm, so stünn door ''n grooten stenern Pallast, un syn Fru stünn ewen up de Trepp und wull henin gaan: do nöhm se em by de Hand und säd "kumm man herein."

Mit des güng he mit ehr henin, un in dem Slott wöör ene grote Dehl mit marmelstenern Asters, und dar wören so veel Be deenters, de reten de grooten Dören up, un de Wende wören all blank un mit schöne Tapeten, un in de Zimmers luter gollne Stöhl und Dischen, un krystallen Kroonlüchters hüngen an dem Bähn, un so wöör dat all de Stuwen und Kamers mit Foot deken: un dat i"iten un de allerbeste Wyn stünn up den Dischen, as wenn se breken wullen. Un achter dem Huse wöör ook''n grooten Hof mit Peerd- und Kohstall, un Kutschwagens up dat allerbeste, ook was door en grooten herrlichen Goorn mit de schönnsten Blomen un fyne Aaftbömer, un en Lustholt wol ''ne halwe Myl lang, door wören Hirschen un Reh un Hasen drin un allens, wat man sik jümmer wünschen mag.

"Na," säd de Fru, "is dat nun nich schön?"

"Ach ja," säd de Mann, "so schallt"t ook blywen, nu wähl wy ook in das schöne Slott wanen un wähl tofreden syn."

"Dat wähl wy uns bedenken," säd de Fru, "un wählen"t beslapen." Mit des güngen se to Bedd.

Den annern Morgen waakd de Fru to eerst up, dat was jüst Dag, un seeg uut jem ehr Bedd dat herrliche Land vör sik liggen. De Mann reckd sik noch, do stödd se em mit dem Ell bagen in de Syd und säd "Mann, sta up un kyk mal uut dem Fenster. Süh, kunnen wy nich König warden äwer all düt Land? Ga hen tom Butt, wy wählt König syn."

"Ach, Fru," säd de Mann, "wat wähln wy König syn! ik mag nich König syn."

"Na," sad de Fru, "wult du nich König syn, so will ik König syn. Ga hen tom Butt, ik will König syn."

"Ach, Fru," säd de Mann, "wat wullst du König syn? dat mag ik em nich seggen."

"Worüm nich?" säd de Fru, "ga stracks hen, ik mutt König syn."

Do güng de Mann hen un wöör ganß bedröft, dat syne Fru König warden wull. "Dat is nich recht un is nicht recht," dachd de Mann. He wull nich hen gaan, güng awerst doch hen. Un as he an de See köhm, do wöör de See ganß swartgrau, un dat Water geerd so von ünnen up und stünk ook ganß fuul. Do güng he staan un säd

"Manntje, Manntje, Timpe Te,
Buttje, Buttje in der See,
Myne Fru, de Ilsebill,
Will nich so, as ik wol will."
"Na wat will se denn?" säd de Butt.

"Ach," säd de Mann, "se will König warden."

"Ga man hen, se is"t all," säd de Butt.

Do güng de Mann hen, und as he na dem Pallast köhm, so wöör dat Slott veel grötter worren, mit enem grooten Toorn un herrlyken Zyraat doran: un de Schildwach stünn vor de Döhr, un dar wören so väle Soldaten un Paüken un Trum peten. Un as he in dat Huus köhm, so wöör allens von purem Marmelsteen mit Gold, un sammtne Deken un groote gollne Quasten. Do güngen de Dören von dem Saal up, door de ganße Hofstaat wöör, un syne Fru seet up enem hogen Troon von Gold und Demant, un hadd ene groote gollne Kroon up un den Zepter in der Hand von purem Gold un Edelsteen, un up beyden Syden by ehr stünnen ses Jumpfern in ene Reeg, jüm mer ene enen Kops lüttjer as de annere.

Do güng he staan und säd "ach, Fru, büst du nu König?"

"Ja," säd de Fru, "nu bün ik König."

Do stünn he und seeg se an, un as he do een Flach so ansehn hadd, säd he "ach, Fru, wat lett dat schöön, wenn du König büst! nu wähl wy ook niks meer wün schen."

"Ne, Mann," säd de Fru un wöör ganß unruhig, "my waart de Tyd un Wyl al lang, ik kann dat nich meer üthollen. Ga hen tom Butt, König bün ik, nu mutt ik ook Kaiser warden."

"Ach, Fru," säd de Mann, "wat wullst du Kaiser warden?"

"Mann," säd se, "ga tom Butt, ik will Kaiser syn."

"Adl, Fru," säd de Mann, "Kaiser kann he nich maken, ik mag dem Butt dat nich seggen; Kaiser is man eenmal im Reich: Kaiser kann de Butt jo nich maken, dat kann un kann he nich."

"Wat," säd de Fru, "ik bünn König, un du büst man myn Mann, wullt du glyk hengaan? glyk ga hen, kann he König maken, kann he ook Kaiser maken, ik will un will Kaiser syn; glyk ga hen."

Do mussd he hengaan. Do de Mann awer hengüng, wöör em ganß bang, un as he so güng, dachd he be sik "düt gait und gait nich good: Kaiser is to uutvörschaamt, de Butt wart am Ende möd." Mit des köhm he an de See, do wöör de See noch ganß swart un dick un füng al so von ünnen up to geeren, dat et so Blasen smeet, un et güng so em Keekwind äwer hen, dat et sik so köhrd; un de Mann wurr groen. Do güng he staan un säd

"Manntje, Manntje, Timpe Te,
Buttje, Buttje in der See,
Myne Fru, de Ilsebill,
Will nich so, as ik wol will."
"Na, wat will se denn?" säd de Butt.

"Ach Butt," säd he, "myn Fru will Kaiser warden."

"Ga man hen," säd de Butt, "se is"t all."

Do güng de Mann hen, un as he door köhm, so wöör dat ganße Slott von poleertem Marmelsteen mit albasternen Figuren un gollnen Zyraten. Vör de Döhr marscheerden die Soldaten und se blösen Trumpeten und slögen Pauken un Trummeln: awerst in dem Huse, da güngen de Baronen un Grawen un Herzogen man so as Bedeenters herüm: do makten se em de Dören up, de von luter Gold wören. Un as he herinköhm, door seet syne Fru up enem Troon, de wöör von een Stück Gold, un wöör wol twe Myl hoog: un hadd ene groote gollne Kroon up, de wöör dre Elen hoog un mit Briljanten un Karfunkelsteen beset-t: in de ene Hand hadde se den Zepter un in de annere Hand den Reichsappel, un up beyden Syden by eer, door stün nen de Trabanten so in twe Regen, jümmer en lüttjer as de annere, von dem allergröttesten Rysen, de wöör twe Myl hoog, bet to dem allerlüttjesten Dwaark, de wöör man so groot as min lüttje Finger. Un vör ehr stünnen so vele Fürsten un Herzogen.

Door güng de Mann tüschen staan und säd "Fru, büst du nu Kaiser?"

"Ja," säd se, "ik bün Kaiser."

Do güng he staan un beseeg se sik so recht, un as he se so''n Flach ansehen hadd, so säd he "ach, Fru, wat lett dat schöön, wenn du Kaiser büst."

"Mann," säd se, "wat staist du door? ik bün nu Kaiser, nu will ik awerst ook Paabst warden, ga hen tom Butt."

"Ach, Fru," säd de Mann, "watt wulst du man nidl? Paabst kannst du nich warden, Paabst is man eenmal in der Kristenhait, dat kann he doch nich maken."

"Mann," säd se, "ik will Paabst warden, ga glyk hen, ik mutt hüüt noch Paabst warden."

"Ne, Fru," säd de Mann, "dat mag ik em nich seggen, dat gait nich good, dat is to groff, tom Paabst kann de Butt nich maken."

"Mann, wat Snack!" säd de Fru, "kann he Kaiser maken, kann he ook Paabst maken. Ga foorts hen, ik bünn Kaiser, un du büst man myn Mann, wult du wol hengaan?"

Do wurr he bang un güng hen, em wöör awerst ganß flau, un zitterd un beewd, un de Knee un de Waden slakkerden em. Un dar streek so''n Wind äwer dat Land, un de Wolken flögen, as dat düster wurr gegen Awend: de Bläder waiden von den Bömern, und dat Water güng un bruusd, as kaakd dat, un platschd an dat i"iver, un von feern seeg he de Schepen, de schöten in der Noot, un danß den un sprüngen up den Bülgen. Doch wöör de Himmel noch so''n bitten blau in de Midd, awerst an den Syden, door toog dat so recht rood up as en swohr Gewitter. Do güng he recht vörzufft staan in de Angst un säd

"Manntje, Manntje, Timpe Te,
Buttje, Buttje in der See,
Myne Fru, de Ilsebill,
Will nich so, as ik wol will."
"Na, wat will se denn?" säd de Butt.

"Ach," säd de Mann, "se will Paabst warden."

"Ga man hen, se is"t all," säd de Butt.

Do güng he hen, un as he door köhm, so wöör dar as en groote Kirch mit luter Pallastens ümgewen. Door drängd he sik dorch dat Volk: inwendig was awer allens mit dausend un dausend Lichtern erleuchtet, un syne Fru wöör in luter Gold gekledet, un seet noch up enem veel högeren Troon, un hadde dre groote gollne Kronen up, un üm ehr dar wöör so veel von geistlykem Staat, un up beyden Syden by ehr, door stünnen twe Regen Lichter, dat gröttste so dick und groot as de allergröttste Toorn, bet to dem allerkleensten Käkenlicht; un alle de Kaisers un de Königen, de legen vör ehr up de Kne und küßden ehr den Tüffel.

"Fru," säd de Mann und seeg se so recht an, "büst du nun Paabst?"

"Ja," säd se, "ik bün Paabst."

Do güng he staan un seeg se recht an, un dat wöör, as wenn he in de hell Sunn seeg. As he se do en Flach ansehn hadd, so segt he "ach, Fru, wat lett dat schöön, wenn du Paabst büst!"

Se seet awerst ganß styf as en Boom, un rüppeld un röhrd sik nich.

Do säd he "Fru, nu sy tofreden, nu du Paabst büst, nu kannst du doch niks meer warden."

"Dat will ik my bedenken," säd de Fru. Mit des güngen se beyde to Bedd, awerst se wöör nich tofreden, un de Girighait leet se nich slapen, se dachd jümmer, wat se noch warden wull. De Mann sleep recht good un fast, he hadd den Dag veel lopen, de Fru awerst kunn goor nich inslapen, un smeet sik von en Syd to der annern de ganße Nacht un dachd man jüm mer, wat se noch wol warden kunn, un kunn sik doch up niks meer besinnen. Mit des wull de Sünn upgan, un as se dat Mar genrood seeg, richt"d se sik äwer End im Bedd un seeg door henin, un as se uut dem Fenster de Sünn so herup kamen seeg, "ha," dachd se, "kunn ik nich ook de Sünn un de Maan upgaan laten?"

"Mann," säd se un stöd em mit dem Ellbagen in de Rib ben, "waak up, ga hen tom Butt, ik will warden as de lewe Gott."

De Mann was noch meist in''n Slaap, awerst he vörschrock sik so, dat he uut dem Bedd füll. He meend, he hadd sik vör höörd, un reef sik de Ogen ut un säd "ach, Fru, wat säd"st du?"

"Mann," säd se, "wenn ik nich de Sünn un de Maan kan upgaan laten, un mutt dat so ansehn, dat de Sünn un de Maan upgaan, ik kann dat nich uuthollen, un hebb kene geruhige Stünd meer, dat ik se nich sülwst kann upgaan laten." Do seeg se em so recht gräsig an, dat em so''n Schudder äwerleep. "Glyk ga hen, ik will warden as de lewe Gott."

"Ach, Fru," säd de Mann, un füll vör eer up de Knee, tdat kann de Butt nich. Kaiser un Paabst kann he maken, ik bidd dy, sla in dy un blyf Paabst."

Do köhm se in de Booshait, de Hoor flögen eher so wild üm den Kopp, do reet se sik dat Lyfken up un geef em eens mit dem Foot un schreed "ik holl dat nich uut, un holl dat nich länger uut, wult du hengaan?"

Do slööpd he sik de Büxen an un leep wech as unsinnig. Buten awer güng de Storm, und bruusde, dat he kuum up de Föten staan kunn: de Huser un de Bömer waiden um, un de Baarge beewden, un de Felsenstücken rullden in de See, un de Himmel wöör ganß pickswart, un dat dunnerd un blitzd, un de See güng in so hoge swarte Bülgen as Kirchentöörn un as Baarge, un de hadden bawen alle ene witte Kroon von Schuum up. So schre he, un kun syn egen Woord nich hören,

"Manntje, Manntje, Timpe Te,
Buttje, Buttje in der See,
Myne Fru, de Ilsebill,
Will nich so, as ik wol will."
"Na, wat will se denn?" säd de Butt.

"Ach," säd he, "se will warden as de lewe Gott."

"Ga man hen, se sitt all weder in''n Pißputt."

Door sitten se noch bet up hüüt un düssen Dag.', 0, 1, true, false, '2017-07-15 12:55:33.300281+08', '2017-07-15 12:59:17.33398+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (28, NULL, 19, 5, 'Free expression isn’t a function of the values of a place but the structure of the information infrastructure.', 'What we think and say is a by product of what we read and who we listen to.

And, what we read and who we listen to is a by-product of the structure of the information infrastructure. The United States is often touted (for good reason) as the bastion of freedom of expression. But, here is an example from not-too-long ago where this completely broke down.
', 0, 0, true, false, '2017-07-15 12:58:40.625067+08', '2017-07-15 12:58:51.413529+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (29, 27, 18, 3, 'Why you should care about Net Neutrality', 'The Motion Picture Production Code
In the 1930s, the entire movie industry in the United States was controlled by a small group of firms — led by Paramount, MGM and Fox. But, the “Motion Pictures Producers and Distributors of America” decided scenes like the one below that depicted gangster violence was morally questionable. In addition, the fact that the entire industry was run by Jewish businessmen at a time when anti-Semitism was rife meant the studios operated with an additional target on their back.', 0, 0, false, false, '2017-07-15 12:59:07.838371+08', '2017-07-15 12:59:07.838371+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (27, NULL, 18, 5, 'Why you should care about Net Neutrality', 'When folks discuss the idea of net neutrality, there are a lot of terms around legislation like “Title I” and “Title 2” and regulatory bodies like the FCC and FTC that are discussed. I’ve linked to articles that dig into this in detail below. While those are interesting pieces of information, I’d like to spend time on why this is a matter of philosophy and principle and why this discussion is very important.
Here are 4 ideas we’ll spend time on today (the “executive summary” if you will)

Freedom of expression isn’t a function of the values of a place but the structure of the information infrastructure. Oppressive regimes led by the likes of Adolf Hitler and Joseph Stalin understood this and used the power of centralized/consolidated information systems to spread propaganda.

- The 1960s were famous for the rejection of these centralized systems (in this case, the Bell/AT&T monopoly). And, the internet was explicitly designed to be network neutral as a way to fight consolidation. Side note: the internet’s design is a work of art.
- This network neutrality or net neutrality means that every service on the internet competes on a level playing field and it is users (i.e. us) that choose which internet service wins. This system brings its own set of issues with it but it is better than the alternative.
- Net neutrality principles are closely aligned with the principles behind the freedom of expression. So, the real question underlying the net neutrality discussion is — how much do you care about freedom of expression?

__Freedom of Expression__

According to the Universal Declaration of Human Rights, freedom of expression is the right of every individual to hold opinions without interference and to seek, receive and impart information and ideas through any media and regardless of frontiers.
The right to freedom of expression is recognized as a human right under Article 19 of the Universal Declaration of Human Rights signed by the United Nations in 1948.
What does the freedom of expression have to do with Net Neutrality? 
Everything, it turns out.', 0, 1, false, false, '2017-07-15 12:58:22.903976+08', '2017-07-15 12:59:07.838371+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (30, 24, 15, 3, 'Von dem Fischer un syner Fru', 'Was ist das?', 0, 0, false, false, '2017-07-15 12:59:17.33398+08', '2017-07-15 12:59:17.33398+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (31, 22, 14, 3, 'Did steam eat the world?', 'So, the MPPDA used the church’s following (which was most of America) to threaten boycott of all movies by these studios. They, thus, succeeded in enforcing what came to be known as the Motion Picture Production Code. The code banned profanity — including words like “God” or “Jesus” if not used in connection with a religious ceremony, relationships between white and black races, any nudity (even in a silhouette) and any ridicule of the clergy or the nation.
The code also restricted, among others, the use of firearms, smuggling, sympathy for criminals, “first-night” scenes and required kissing, for example, to only last 3 seconds. It required good to be good and evil to be evil and, thus, created the “Hollywood ending.”', 0, 0, false, false, '2017-07-15 12:59:29.606621+08', '2017-07-15 12:59:29.606621+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (32, NULL, 20, 4, 'Apple’s Next Move? It’s Obvious. But We’re Missing It.', 'It was 1998 and, as described in ‘Good Strategy, Bad Strategy’, Richard Rumelt asked Steve Jobs how he was going to grow Apple from a niche play into a company well worth more than the $150M Bill Gates had recently invested. Jobs had recently returned to the company he’d founded and was successfully turning things around. Jobs had convinced Gates that investing in Apple, and keeping the company alive, would help Microsoft get past the issues it was having with the Justice Department. Gates invested. Jobs cut all but one of the fifteen desktop computers. He also reduced the number of portables and focused on one laptop. The decision was made to sell directly to customers online.', 0, 0, false, false, '2017-07-15 12:59:56.337152+08', '2017-07-15 12:59:56.337152+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (33, 18, 12, 4, 'How I’m using Instagram Stories', 'This focus allowed Apple to cut inventory by 80%. The company was back in the game. But, by its competitor’s standards, Apple was small owning less than 4% market share. And Rumelt, strategist and author, wanted to know how Jobs was going to propel the company forward;

“Rumelt: Steve, this turnaround at Apple has been impressive. But everything we know about the PC business says that Apple cannot really push beyond a small niche position. The network effects are just too strong to upset the Wintel standard. So what are you trying to do in the longer term? What is the strategy?”

Jobs: “I am going to wait for the next big thing.”', 0, 0, false, false, '2017-07-15 13:00:16.047178+08', '2017-07-15 13:00:16.047178+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (35, NULL, 22, 7, 'Froschkönig', 'In den alten Zeiten, wo das Wünschen noch geholfen hat, lebte ein König, dessen Töchter waren alle schön, aber die jüngste war so schön, daß sich die Sonne selber, die doch so vieles gesehen hat, darüber verwunderte so oft sie ihr ins Gesicht schien.

Nahe bei dem Schlosse des Königs lag ein großer dunkler Wald, und in dem Walde unter einer alten Linde war ein Brunnen: wenn nun der Tag recht heiß war, so ging das Königskind hinaus in den Wald, und setzte sich an den Rand des kühlen Brunnens, und wenn sie Langeweile hatte, so nahm sie eine goldene Kugel, warf sie in die Höhe und fing sie wieder; und das war ihr liebstes Spielwerk.

Nun trug es sich einmal zu, daß die goldene Kugel der Königstochter nicht in das Händchen fiel, das sie ausgestreckt hatte, sondern neben vorbei auf die Erde schlug, und geradezu ins Wasser hinein rollte. Die Königstochter folgte ihr mit den Augen nach, aber die Kugel verschwand, und der Brunnen war tief, und gar kein Grund zu sehen. Da fing sie an zu weinen, und weinte immer lauter, und konnte sich gar nicht trösten.

Und wie sie so klagte, rief ihr jemand zu "was hast du vor, Königstochter, du schreist ja daß sich ein Stein erbarmen möchte". Sie sah sich um, woher die Stimme käme, da erblickte sie einen Frosch, der seinen dicken häßlichen Kopf aus dem Wasser streckte.

"Ach, du bists, alter Wasserpatscher", sagte sie, "ich weine über meine goldne Kugel, die mir in den Brunnen hinab gefallen ist."

"Gib dich zufrieden", antwortete der Frosch, "ich kann wohl Rat schaffen, aber was gibst du mir, wenn ich dein Spielwerk wieder heraufhole?"

"Was du willst, lieber Frosch", sagte sie, "meine Kleider, meine Perlen und Edelsteine, dazu die goldne Krone, die ich trage."

Der Frosch antwortete "deine Kleider, deine Perlen und Edelsteine, deine goldne Krone, die mag ich nicht: aber wenn du mich lieb haben willst, und ich soll dein Geselle und Spielkamerad sein, an deinem Tischlein neben dir sitzen, von deinem goldnen Tellerlein essen, aus deinem Becherlein trinken, in deinem Bettlein schlafen: wenn du mir das versprichst, so will ich dir die goldne Kugel wieder aus dem Grunde hervor holen".

"Ach ja", sagte sie, "ich verspreche dir alles,, wenn du mir nur die Kugel wieder bringst." Sie dachte aber "was der einfältige Frosch schwätzt, der sitzt im Wasser bei seines Gleichen, und quakt, und kann keines Menschen Geselle sein".

Der Frosch, als er die Zusage erhalten hatte, tauchte seinen Kopf unter, sank hinab, und über ein Weilchen kam er wieder herauf gerudert, hatte die Kugel im Maul, und warf sie ins Gras.

Die Königstochter war voll Freude, als sie ihr schönes Spielwerk wieder erblickte, hob es auf, und sprang damit fort. "Warte, warte", rief der Frosch, "nimm mich mit, ich kann nicht so laufen wie du." Aber was half ihm daß er ihr sein quak quak so laut nachschrie als er konnte! sie hörte nicht darauf, eilte nach Haus, und hatte bald den armen Frosch vergessen, der wieder in den tiefen Brunnen hinab steigen mußte.


Am andern Tage, als sie mit dem König und allen Hofleuten an der Tafel saß, und von ihrem goldnen Tellerlein aß, da kam, plitsch platsch, plitsch platsch, etwas die Marmortreppe herauf gekrochen, und als es oben angelangt war, klopfte es an der Tür, und rief "Königstochter, jüngste, mach mir auf".

Sie lief und wollte sehen wer draußen wäre, als sie aber aufmachte, so saß der Frosch davor. Da warf sie die Tür hastig zu, setzte sich wieder an den Tisch, und war ihr ganz angst.

Der König sah daß ihr das Herz gewaltig klopfte, und sprach "ei, was fürchtest du dich, steht etwa ein Riese vor der Tür, und will dich holen?"

"Ach nein", antwortete das Kind, "es ist kein Riese, sondern ein garstiger Frosch, der hat mir gestern im Wald meine goldene Kugel aus dem Wasser geholt, dafür versprach ich ihm er sollte mein Geselle werden, ich dachte aber nimmermehr daß er aus seinem Wasser heraus könnte: nun ist er draußen, und will zu mir herein."

Indem klopfte es zum zweitenmal und rief, "Königstochter, jüngste, mach mir auf, weißt du nicht was gestern du zu mir gesagt bei dem kühlen Brunnenwasser? Königstochter, jüngste, mach mir auf."

Da sagte der König "hast du''s versprochen, mußt du''s auch halten; geh und mach ihm auf".

Sie ging und öffnete die Türe, da hüpfte der Frosch herein, ihr immer auf dem Fuße nach, bis zu ihrem Stuhl. Da saß er und rief "heb mich herauf zu dir".

Sie wollte nicht bis es der König befahl. Als der Frosch auf den Stuhl gekommen war, sprach er "nun schieb mir dein goldenes Tellerlein näher, damit wir zusammen essen".

Das tat sie auch, aber man sah wohl daß sies nicht gerne tat. Der Frosch ließ sichs gut schmecken, aber ihr blieb fast jedes Bißlein im Halse.

Endlich sprach er "nun hab ich mich satt gegessen, und bin müde, trag mich hinauf in dein Kämmerlein, und mach dein seiden Bettlein zurecht, da wollen wir uns schlafen legen".

Da fing die Königstochter an zu weinen, und fürchtete sich vor dem kalten Frosch, den sie nicht anzurühren getraute, und der nun in ihrem schönen reinen Bettlein schlafen sollte.

Der König aber blickte sie zornig an, und sprach "was du versprochen hast, sollst du auch halten, und der Frosch ist dein Geselle".

Es half nichts, sie mochte wollen oder nicht, sie mußte den Frosch mitnehmen. Da packte sie ihn, ganz bitterböse, mit zwei Fingern, und trug ihn hinauf, und als sie im Bett lag, statt ihn hinein zu heben, warf sie ihn aus allen Kräften an die Wand und sprach "nun wirst du Ruhe haben, du garstiger Frosch".

Was aber herunter fiel war nicht ein toter Frosch, sondern ein lebendiger junger Königssohn mit schönen und freundlichen Augen. Der war nun von Recht und mit ihres Vaters Willen ihr lieber Geselle und Gemahl. Da schliefen sie vergnügt zusammen ein, und am andern Morgen, als die Sonne sie aufweckte, kam ein Wagen herangefahren mit acht weißen Pferden bespannt, die waren mit Federn geschmückt, und gingen in goldenen Ketten, und hinten stand der Diener des jungen Königs, das war der treue Heinrich.

Der treue Heinrich hatte sich so betrübt, als sein Herr war in einen Frosch verwandelt worden, daß er drei eiserne Bande hatte müssen um sein Herz legen lassen, damit es ihm nicht vor Weh und Traurigkeit zerspränge. Der Wagen aber sollte den jungen König in sein Reich abholen; der treue Heinrich hob beide hinein, und stellte sich wieder hinten auf, voller Freude über die Erlösung.

Und als sie ein Stück Wegs gefahren waren, hörte der Königssohn hinter sich daß es krachte, als wäre etwas zerbrochen. Da drehte er sich um, und rief "Heinrich, der Wagen bricht."

"Nein, Herr, der Wagen nicht, es ist ein Band von meinem Herzen, 
das da lag in großen Schmerzen,
als ihr in dem Brunnen saßt,
als ihr eine Fretsche (Frosch) was''t (wart)."

Noch einmal und noch einmal krachte es auf dem Weg, und der Königssohn meinte immer der Wagen bräche, und es waren doch nur die Bande, die vom Herzen des treuen Heinrich absprangen, weil sein Herr wieder erlöst und glücklich war.', 0, 0, false, false, '2017-07-15 13:01:12.632932+08', '2017-07-15 13:01:12.632932+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (36, 34, 21, 7, 'Is the Homepod a diversionary play?', 'Before jumping into what I think Apple’s next play is, the trends do not look so good for the platforms/products where Apple has traditionally made the bulk of its money.', 0, 0, false, false, '2017-07-15 13:01:30.829638+08', '2017-07-15 13:01:30.829638+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (34, NULL, 21, 4, 'Is the Homepod a diversionary play?', 'In the last few days (July 2017) Apple started letting customers test Homekit, its smart home development platform, in stores across the world. A few months ago, Apple announced Homepod its voice-activated smart speaker which, along with playing music as music should be listened to, acts as the hub for all the connected devices with apps built on the Homekit platform. A few connected devices manufacturers — Phillips, Nest, Lutron etc- have built apps on the Homekit platform that you can control through the Homepod, iPhone or Apple Watch.
But this is all ‘me-too’ stuff at this point. Amazon, Google and even Samsung (through the acquisition of SmartThings) all have connected home hubs and developer platforms. In my view, the positioning of the Homepod as a music listening device is a deflection from what I truly believe Apple is planning for the connected home. While Homepod is a critical part of the strategy, it is not the core piece in this puzzle.
', 0, 1, false, false, '2017-07-15 13:00:32.340348+08', '2017-07-15 13:01:30.829638+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (37, 25, 16, 7, 'Aiming for perfection in writing', 'Thanks for this.', 0, 0, false, false, '2017-07-15 13:01:46.54716+08', '2017-07-15 13:01:46.54716+08');
INSERT INTO post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) VALUES (25, NULL, 16, 5, 'Aiming for perfection in writing', '_I remember when I used to think, “man, I can’t share this article I just wrote to social media, people will criticize me, they’ll think I’m just another aspiring person chasing something stupid, or they’ll laugh”._

People did none of those things, really. I was told to just start posting my writing to social media because you never know who will see it or share it. I was also told that you’re always going to have people that criticize your stuff. It’s okay and frankly, it’s part of life.
I mean, I’ve always been a fairly confident person, but being vulnerable to an audience of a ton, or an audience of none, still counts as being vulnerable.

I’ve seen a lot of writers here on Medium say that the posts they write that become the most popular, are the ones that they never thought would leave the ground. They also add that some of the posts they put the most time and effort into see 3 sets of eyeballs and never emerge as anything special.
If this is the case, why is everyone worried about their post being perfect before publishing or sharing? My posts have been roughly the same pattern. The posts that I felt weren’t my best writing got more attention than some that I worked harder on, did research for, and cared about more.
If perfection is what you’re aiming for, you won’t reach it. You may put together an amazing piece about studies showing a reliable chance of unicorns being real. Maybe even a few people have spotted them. You reference all the reputable sites and you execute an accurate flow of information. All of this is capped off by a great conclusion.
It doesn’t matter if nobody wants to read about the possibility of unicorns being real, though. Side note — that actually would be a really intriguing read to me, so maybe that’s a bad example. Point is, you could miss one word in the headline that would otherwise grab a bunch more views, but instead no one is reading your stuff because you didn’t throw enough “power” words in there, whatever that means.

> “Beauty is in the eye of the beholder”, right? Perfection is subjective. Who decides what a perfect piece of writing really is? Your mom? Probably not. She’s most likely biased and will like most things you put your time and effort into. Yourself? No. You struggle with needing perfection and also criticize your own writing more than anyone, remember?', 0, 1, false, false, '2017-07-15 12:56:42.160946+08', '2017-07-15 13:01:46.54716+08');


ALTER TABLE posting.post
ADD CONSTRAINT topic_parent_post_id_fkey FOREIGN KEY (parent_post_id)
REFERENCES posting.post(post_id);


SELECT pg_catalog.setval('post_post_id_seq', 37, true);
