-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema producedb
-- -----------------------------------------------------
-- This is the database for PLU price tracking
DROP SCHEMA IF EXISTS `producedb` ;

-- -----------------------------------------------------
-- Schema producedb
--
-- This is the database for PLU price tracking
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `producedb` DEFAULT CHARACTER SET utf8 ;
USE `producedb` ;

-- -----------------------------------------------------
-- Table `user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `user` ;

CREATE TABLE IF NOT EXISTS `user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(100) NOT NULL,
  `enabled` TINYINT NULL,
  `role` VARCHAR(45) NULL,
  `created_date` DATETIME NULL,
  `login_timestamp` DATETIME NULL,
  `about_me` TEXT NULL,
  `profile_pic` VARCHAR(2000) NULL,
  `first_name` VARCHAR(45) NULL,
  `last_name` VARCHAR(45) NULL,
  `email` VARCHAR(100) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ingredient`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ingredient` ;

CREATE TABLE IF NOT EXISTS `ingredient` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL,
  `description` TEXT(0) NULL,
  `upc` VARCHAR(45) NULL,
  `img_url` VARCHAR(2000) NULL,
  `plu` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `company`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `company` ;

CREATE TABLE IF NOT EXISTS `company` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `api_host_url` VARCHAR(2000) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `store`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `store` ;

CREATE TABLE IF NOT EXISTS `store` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `street1` VARCHAR(100) NULL,
  `street2` VARCHAR(45) NULL,
  `city` VARCHAR(45) NULL,
  `state` VARCHAR(2) NULL,
  `zipcode` VARCHAR(45) NULL,
  `company_id` INT NOT NULL,
  `location_id` INT NULL,
  `name` VARCHAR(200) NULL,
  `phone` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_location_store1_idx` (`company_id` ASC),
  CONSTRAINT `fk_location_store1`
    FOREIGN KEY (`company_id`)
    REFERENCES `company` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipe`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipe` ;

CREATE TABLE IF NOT EXISTS `recipe` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NULL,
  `description` TEXT NULL,
  `img_url` VARCHAR(2000) NULL,
  `creation_date` DATETIME NULL,
  `instructions` TEXT NULL,
  `prep_time` INT NULL,
  `cook_time` INT NULL,
  `published` TINYINT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_recipe_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_recipe_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `user_favorite_store`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `user_favorite_store` ;

CREATE TABLE IF NOT EXISTS `user_favorite_store` (
  `user_id` INT NOT NULL,
  `store_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `store_id`),
  INDEX `fk_user_has_location_location1_idx` (`store_id` ASC),
  INDEX `fk_user_has_location_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_user_has_location_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_has_location_location1`
    FOREIGN KEY (`store_id`)
    REFERENCES `store` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `favorite_recipe`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `favorite_recipe` ;

CREATE TABLE IF NOT EXISTS `favorite_recipe` (
  `recipe_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`recipe_id`, `user_id`),
  INDEX `fk_recipe_has_user_user1_idx` (`user_id` ASC),
  INDEX `fk_recipe_has_user_recipe1_idx` (`recipe_id` ASC),
  CONSTRAINT `fk_recipe_has_user_recipe1`
    FOREIGN KEY (`recipe_id`)
    REFERENCES `recipe` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipe_has_user_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipe_ingredient`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipe_ingredient` ;

CREATE TABLE IF NOT EXISTS `recipe_ingredient` (
  `recipe_id` INT NOT NULL,
  `ingredient_id` INT NOT NULL,
  `measurement` VARCHAR(45) NULL,
  PRIMARY KEY (`recipe_id`, `ingredient_id`),
  INDEX `fk_recipe_has_ingredient_ingredient1_idx` (`ingredient_id` ASC),
  INDEX `fk_recipe_has_ingredient_recipe1_idx` (`recipe_id` ASC),
  CONSTRAINT `fk_recipe_has_ingredient_recipe1`
    FOREIGN KEY (`recipe_id`)
    REFERENCES `recipe` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipe_has_ingredient_ingredient1`
    FOREIGN KEY (`ingredient_id`)
    REFERENCES `ingredient` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `reaction`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `reaction` ;

CREATE TABLE IF NOT EXISTS `reaction` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `emoji` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipe_reaction`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipe_reaction` ;

CREATE TABLE IF NOT EXISTS `recipe_reaction` (
  `recipe_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `reaction_id` INT NOT NULL,
  `reaction_date` DATETIME NULL,
  PRIMARY KEY (`recipe_id`, `user_id`),
  INDEX `fk_recipe_has_user_user2_idx` (`user_id` ASC),
  INDEX `fk_recipe_has_user_recipe2_idx` (`recipe_id` ASC),
  INDEX `fk_recipe_reaction_reaction1_idx` (`reaction_id` ASC),
  CONSTRAINT `fk_recipe_has_user_recipe2`
    FOREIGN KEY (`recipe_id`)
    REFERENCES `recipe` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipe_has_user_user2`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipe_reaction_reaction1`
    FOREIGN KEY (`reaction_id`)
    REFERENCES `reaction` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipe_comment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipe_comment` ;

CREATE TABLE IF NOT EXISTS `recipe_comment` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `comment_date` DATETIME NULL,
  `comment` TEXT NULL,
  `user_id` INT NOT NULL,
  `recipe_id` INT NOT NULL,
  `in_reply_to` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_recipe_comment_user1_idx` (`user_id` ASC),
  INDEX `fk_recipe_comment_recipe1_idx` (`recipe_id` ASC),
  INDEX `fk_recipe_comment_recipe_comment1_idx` (`in_reply_to` ASC),
  CONSTRAINT `fk_recipe_comment_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipe_comment_recipe1`
    FOREIGN KEY (`recipe_id`)
    REFERENCES `recipe` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipe_comment_recipe_comment1`
    FOREIGN KEY (`in_reply_to`)
    REFERENCES `recipe_comment` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `client_access`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `client_access` ;

CREATE TABLE IF NOT EXISTS `client_access` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `apikey` VARCHAR(2000) NULL,
  `expiration` TIMESTAMP NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `category` ;

CREATE TABLE IF NOT EXISTS `category` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ingredient_has_category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ingredient_has_category` ;

CREATE TABLE IF NOT EXISTS `ingredient_has_category` (
  `ingredient_id` INT NOT NULL,
  `category_id` INT NOT NULL,
  PRIMARY KEY (`ingredient_id`, `category_id`),
  INDEX `fk_ingredient_has_category_category1_idx` (`category_id` ASC),
  INDEX `fk_ingredient_has_category_ingredient1_idx` (`ingredient_id` ASC),
  CONSTRAINT `fk_ingredient_has_category_ingredient1`
    FOREIGN KEY (`ingredient_id`)
    REFERENCES `ingredient` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ingredient_has_category_category1`
    FOREIGN KEY (`category_id`)
    REFERENCES `category` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SET SQL_MODE = '';
DROP USER IF EXISTS produceuser@localhost;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'produceuser'@'localhost' IDENTIFIED BY 'produceuser';

GRANT SELECT, INSERT, TRIGGER, UPDATE, DELETE ON TABLE * TO 'produceuser'@'localhost';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `user`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (1, 'admin', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'ADMIN', '2022-11-23T00:00:00', NULL, 'You is kind, you is smart, you is important.', 'https://static.wikia.nocookie.net/p__/images/9/9b/1b13cb476ad9a9befc0fa6a04512ef05--movie-stars-famous-people.jpg/revision/latest?cb=20170812234028&path-prefix=protagonist', NULL, NULL, NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (2, 'jdoe', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'USER', '2022-11-23T00:00:00', NULL, 'I survived because the fire inside me burned brighter than the fire around me.', 'https://pyxis.nymag.com/v1/imgs/654/1f1/08de774c11d89cb3f4ecf600a33e9c8283-24-keanu-reeves.rsquare.w700.jpg', 'John', 'Doe', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (3, 'NoobMstr', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', '2022-11-23T00:00:00', NULL, 'I am a user', 'https://static.wikia.nocookie.net/die-hard-scenario/images/f/f5/394px-Holly_phoning_home.jpg', 'Holly', 'McClain', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (4, 'FoodFan', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Die having memories don’t die with just dreams.', 'https://www.looper.com/img/gallery/what-you-didnt-know-about-mike-smith-from-trailer-park-boys/l-intro-1602252328.jpg', 'Mike', 'Smith', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (5, 'WingLover', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Take care of your body, it’s the only place you have to live.
', 'https://i.insider.com/60b79ca3bee0fc0019d5ad78?width=1000&format=jpeg&auto=webp', 'Jeff', 'Johnson', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (6, 'RiceGuy', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Stay humble. Be kind. Work hard.', 'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/american-actor-anthony-michael-hall-poses-for-a-photograph-news-photo-1640879164.jpg', 'Rob', 'Dobb', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (7, 'ShwarmaKarma', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Throwing kindness around like confetti.', 'http://images6.fanpop.com/image/polls/1237000/1237408_1372157539132_full.jpg?v=1372157542', 'Alice', 'Samsonite', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (8, 'ChiffonadeGirl', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Things about things', 'https://i.insider.com/60b79ad0bee0fc0019d5ad6c?width=1000&format=jpeg&auto=webp', 'Alec', 'Redding', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (9, 'RoughChop', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Don’t ever be afraid to shine.
', 'https://www.wonderwall.com/wp-content/uploads/sites/2/2022/11/lessthanzero1987_09.jpg', 'Billy', 'Baldwin', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (10, 'ChefGirl', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Creating my own sunshine.
', 'https://i.insider.com/60b7b1a4bee0fc0019d5ae00?width=1000&format=jpeg&auto=webp', 'Cullen', 'Stephan', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (11, 'YesChef', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Going where I feel most alive.
', 'https://cdn-assets.ziniopro.com/var/site_2043/storage/images/media2/images/f0033-0166/614078-1-eng-GB/f0033-012.jpg?t=default_ipad_portrait', 'Nolan', 'MacGregor', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (12, 'TBone22', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Your life does not get better by chance. It gets better by a change.
', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRMMBpRMmpaDkNHRDAxgBJejvnWW24sOTipiw&usqp=CAU', 'Aspen', 'Mills', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (13, 'SaladGuy33', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Life is not a problem to be solved but a reality to be experienced.
', 'https://www.wonderwall.com/wp-content/uploads/sites/2/2020/06/mare-winningham-st-elmos-fire.jpg?h=800', 'Mackenzie', 'Parks', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (14, 'RatatouilleRay', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'I would rather die of passion than of boredom.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-dD8QpiZ-M98ApBn12pgN48Fbb9CHlYsHHw&usqp=CAU', 'Maximiliaan', 'Rafferty', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (15, 'HotPocket', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'When daydreams become reality.
', 'https://i.pinimg.com/originals/c0/29/b0/c029b0e54d2f2b5f048096249b4d94a6.jpg', 'Logan', 'Shogun', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (16, 'FeedMe67', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Perseverance pays… a lot!
', 'https://cdn.fstoppers.com/wp-content/uploads/2013/06/a97970_gshots_scout.jpg', 'Juliette', 'Peaks', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (17, 'EatThis11', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'The best of me is yet to come.
', 'https://i.pinimg.com/originals/0d/46/ba/0d46ba10646120420a7eff8910a89d26.jpg', 'Fonz', 'Caliente', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (18, 'Chopped', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'It wasn’t always easy but it’s worth it.
', 'https://cdn.fstoppers.com/wp-content/uploads/2013/06/a97970_glamour-shotsboa.jpg', 'Loki', 'poki', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (19, 'RecipeKing', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Gifted napper, talker, and ice cream eater.
', 'https://i.pinimg.com/236x/80/5a/a9/805aa9816c2df818ca1971ada203a2b6--glamour-shots-photo-s.jpg', 'Thomas', 'Train', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (20, 'HereForNuggets', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Do you know what I like about people? Their dogs.
', 'https://cdn.fstoppers.com/wp-content/uploads/2013/06/1.jpg', 'Tomas', 'Trains', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (21, 'TomahawkChop', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'First I drink the coffee. Then I do things.
', 'https://i.pinimg.com/originals/5b/65/12/5b6512dcfbfc23910c9b5117a0988b08.jpg', 'Lilly', 'Milly', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (22, 'BraisedForDays', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'I already want to take a nap tomorrow.
', 'https://content.invisioncic.com/r232321/monthly_2020_06/835629544_glamourshots6.jpg.0eebdbb5423e197eae568d53dcd7b952.jpg', 'Roberto', 'Thurto', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (23, 'AuntBessie', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Good times and tan lines.
', 'https://awkwardfamilyphotos.com/wp-content/uploads/2022/01/Screen-Shot-2022-01-17-at-1.53.34-PM-819x1024.jpg', 'Jin', 'Win', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (24, 'AllGravy', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'My mission in life is not merely to survive but thrive.
', 'https://external-preview.redd.it/KVxRMUn1oVUShDXEI2ApocWYVziIW5J42cBfvcbu7ts.jpg?width=640&crop=smart&auto=webp&s=2dbb0fb5db8df673d91589764253f572cde33283', 'Landon', 'Smith', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (25, 'YourMom', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Everything has beauty but not everyone can see.
', 'https://i.pinimg.com/originals/5f/e9/e6/5fe9e62f38e2f00a9bba94f810db95c3.jpg', 'Rick', 'MacGregor', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (26, 'MyMom', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Remember to always be yourself.
', 'https://i.pinimg.com/736x/7e/5a/b9/7e5ab9c1604f9743b996693d21d479fa--man-bun-s-hair.jpg', 'Michael', 'Mills', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (27, 'FindMyPeas', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Happiness often sneaks in through a door you didn’t know you left open.
', 'https://i.pinimg.com/originals/21/b7/6d/21b76d6a8bfb0120500976a8b141ef6c.jpg', 'Roxanne', 'Parks', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (28, 'PicklesIsMyName', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'If I cannot do great things, I can do small things in a great way.
', 'https://pbs.twimg.com/media/CJ908ltVEAAqBIS.jpg', 'Jimmy', 'Rafferty', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (29, 'FindTheSaltine', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'The bad news is time flies. The good news is you’re the pilot.
', 'https://cdn.fstoppers.com/wp-content/uploads/2013/06/154-2.jpg', 'Jolie', 'Shogun', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (30, 'Grains1111', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Sometimes you will never know the value of a moment until it becomes a memory.
', 'https://cdn.ebaumsworld.com/mediaFiles/picture/2183782/84582542.jpg', 'Samwise', 'Peaks', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (31, 'Pasta4Brekky', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'We have nothing to fear but fear itself.
', 'https://i.pinimg.com/736x/16/79/7b/16797bda9f63c8ab2400f08fce945e2f--glamour-shoot-jean-jackets.jpg', 'Mary', 'Caliente', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (32, 'CannedHam', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '“Be strong,” I whisper to my WiFi signal.', 'https://sadanduseless.b-cdn.net/wp-content/uploads/2018/11/men-with-cats11.jpg', 'Anthony', 'poki', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (33, 'SlamminSalmon', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Chocolate never asks me any questions, chocolate understands me.
', 'https://img.izismile.com/img/img9/20160831/640/these_pics_will_prove_you_how_cringeworthy_lowbudget_glamour_shots_are_640_23.jpg', 'William', 'Train', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (34, 'ShoNuff', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Recovering from donuts addiction.
', 'https://external-preview.redd.it/nbCLRNTWKbdINsqdtgjaO6NA_xEHX3hXakmn9ySD3-g.jpg?auto=webp&s=ea82cce5b5f6bf7b23f0b8ab208a8632a0287631', 'William', 'Trains', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (35, 'SparaGuss', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Words cannot express my love and passion for Fridays. The photos might help.
', 'https://static.frieze.com/files/inline-images/editorial-articles-54.bmp', 'Lulu', 'Milly', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (36, 'FancyFeast', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Sometimes I just want to give it all up and become a handsome billionaire.
', 'https://cdn.fstoppers.com/wp-content/uploads/2013/06/912.jpg', 'Sam', 'Thurto', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (37, 'ReallyFancyFeast', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Here to serve… The cat overlord.
', 'https://jaiophotography.com/wp-content/uploads/2015/09/fashion-male-1.jpg', 'Adamo', 'Win', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (38, 'Brainiac', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'I’m actually not funny. I’m just really mean and people think I’m joking.
', 'https://d7hftxdivxxvm.cloudfront.net/?height=788&quality=80&resize_to=fit&src=https%3A%2F%2Fd32dm0rphc51dk.cloudfront.net%2Fe56Vf9Ymdk6_2LGO-UXZRA%2Fnormalized.jpg&width=800', 'Conor', 'Smith', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (39, 'DeepFried', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Life is short… smile while you still have teeth.
', 'https://piximus.net/media/36093/glam-photos-of-the-80s-1.jpg', 'Connor', 'MacGregor', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (40, '2Changs', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'I’m not sure how many problems I have because math is one of them.
', 'https://media.istockphoto.com/id/172435108/photo/early-nineties-glamour-shot.jpg?s=612x612&w=0&k=20&c=VKFVqk6xZTUzKyQZx3wz04qoRO6qqZ4lLrLFCUeS1vo=', 'Mark', 'Mills', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (41, 'HotDoggyDog', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'A caffeine dependent life form.
', 'https://sadanduseless.b-cdn.net/wp-content/uploads/2020/05/low-budget-glamour-shots16.jpg', 'Philip', 'Parks', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (42, 'CheesePlease', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Single and ready to get nervous around anyone I find attractive.
', 'https://cdn.fstoppers.com/wp-content/uploads/2013/06/512.jpg', 'Pria', 'Rafferty', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (43, 'Hamburgler', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Hard work never killed anyone, but why take the chance?
', 'https://cdn.trendhunterstatic.com/thumbs/awkward-glamour-shots.jpeg?auto=webp', 'Chris', 'Shogun', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (44, 'FishSticks33', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'My relationship status? Netflix, Oreos, and sweatpants.
', 'https://i.pinimg.com/originals/bb/da/fd/bbdafd2883420ea536f1232a5ea63ead.jpg', 'Savannah', 'Peaks', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (45, 'HalfCupofLove', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'I hope one day I will love something the way women in commercials love yogurt.
', 'https://i.pinimg.com/originals/f8/6a/ec/f86aec8d6fc0f7528a7af4f8bfe4efef.jpg', 'Jenny', 'Caliente', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (46, 'DashOfFunk20', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'We’re all just molecules.
', 'https://i.pinimg.com/736x/20/53/e2/2053e282b6eff139c1b98f34a620500c--glamour-shoot-awkward-photos.jpg', 'Maddux', 'poki', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (47, 'PantsedOne', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'I always prefer my puns to be intended.
', 'https://awkwardfamilyphotos.com/wp-content/uploads/2020/03/IMG_5390.jpg', 'Bimini', 'Train', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (48, 'Whomsit', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'My hobbies are breakfast, lunch, and dinner.
', 'https://www.ozarksfirst.com/wp-content/uploads/sites/65/2021/05/8.jpg?w=865', 'Remmy', 'Trains', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (49, 'ThawedLady67', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'To truly live is the greatest adventure there is.
', 'https://cdn.fstoppers.com/wp-content/uploads/2013/06/bad-glamour-shots-16.jpg', 'Kate', 'Milly', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (50, 'DebonedAndAlone', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Escaping the ordinary.
', 'https://cdn.ebaumsworld.com/mediaFiles/picture/2183782/84582530.jpg', 'Cal', 'Thurto', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `ingredient`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `ingredient` (`id`, `name`, `description`, `upc`, `img_url`, `plu`) VALUES (1, 'Flourexample', 'wheat based powder ', NULL, NULL, NULL);
INSERT INTO `ingredient` (`id`, `name`, `description`, `upc`, `img_url`, `plu`) VALUES (2, 'Waterexample', 'H2O', NULL, NULL, NULL);
INSERT INTO `ingredient` (`id`, `name`, `description`, `upc`, `img_url`, `plu`) VALUES (3, 'Saltexample', 'table salt, iodized', NULL, NULL, NULL);
INSERT INTO `ingredient` (`id`, `name`, `description`, `upc`, `img_url`, `plu`) VALUES (4, 'ground duckexample', 'farm raised ground duck 1 lb', NULL, NULL, NULL);
INSERT INTO `ingredient` (`id`, `name`, `description`, `upc`, `img_url`, `plu`) VALUES (5, 'smoked paprikaexample', 'paprika, smoked', NULL, NULL, NULL);
INSERT INTO `ingredient` (`id`, `name`, `description`, `upc`, `img_url`, `plu`) VALUES (6, 'cooking wineexample', 'spirits for cooking and deglazing', NULL, NULL, NULL);
INSERT INTO `ingredient` (`id`, `name`, `description`, `upc`, `img_url`, `plu`) VALUES (7, 'white onionsexample', 'white onions', NULL, NULL, NULL);
INSERT INTO `ingredient` (`id`, `name`, `description`, `upc`, `img_url`, `plu`) VALUES (8, 'garlicexample', 'garlic cloves', NULL, NULL, NULL);
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (9,'Apple - Southern Rose',NULL,'0000000003001',NULL,'3001');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (10,'Abate Fetel Pears',NULL,'0000000003012',NULL,'3012');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (11,'Pears Concorde',NULL,'0000000003016','https://www.kroger.com/product/images/small/front/0000000003016','3016');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (12,'Tangerines - Satsuma - Mammoth',NULL,'0000000003029','https://www.kroger.com/product/images/large/front/0000000003029','3029');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (13,'Nectarines â€" White',NULL,'0000000003035','https://www.kroger.com/product/images/large/front/0000000003035','3035');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (14,'Dragon Fruit - Pitahaya',NULL,'0000000003040','https://www.kroger.com/product/images/large/front/0000000003040','3040');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (15,'Rambutan',NULL,'0000000003041','https://www.kroger.com/product/images/large/front/0000000003041','3041');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (16,'Mangosteen',NULL,'0000000003042',NULL,'3042');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (17,'Plumcots Velvet 3 Layer',NULL,'0000000003044',NULL,'3044');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (18,'Medjool Dates',NULL,'0000000003047',NULL,'3047');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (19,'Southern Field Aloe Vera Leaves',NULL,'0000000003064',NULL,'3064');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (20,'Apple - Cameo',NULL,'0000000003065','https://www.kroger.com/product/images/large/front/0000000003065','3065');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (21,'Apples - Cameo - Large',NULL,'0000000003066','https://www.kroger.com/product/images/large/front/0000000003066','3066');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (22,'Bakery Artisan Bread',NULL,'0000000003067',NULL,'3067');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (23,'Purple Asparagus Bunch',NULL,'0000000003079',NULL,'3079');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (24,'Broccoli Crowns',NULL,'0000000003082','https://www.kroger.com/product/images/large/front/0000000003082','3082');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (25,'Brussels Sprouts - Stalk',NULL,'0000000003083','https://www.kroger.com/product/images/large/front/0000000003083','3083');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (26,'Large Indian Corn',NULL,'0000000003085',NULL,'3085');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (27,'Mini Indian Corn',NULL,'0000000003086',NULL,'3086');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (28,'Corn - Indian',NULL,'0000000003087',NULL,'3087');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (29,'Eggplant Chinese',NULL,'0000000003089','https://www.kroger.com/product/images/large/front/0000000003089','3089');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (30,'Eggplant - Thai',NULL,'0000000003090','https://www.kroger.com/product/images/large/front/0000000003090','3090');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (31,'Frieda''s Gobo Root',NULL,'0000000003091',NULL,'3091');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (32,'Oroblancos',NULL,'0000000003092',NULL,'3092');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (33,'Kale - Purple Flowering',NULL,'0000000003095','https://www.kroger.com/product/images/large/front/0000000003095','3095');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (34,'Frieda''s Purple Kohlrabi',NULL,'0000000003096',NULL,'3096');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (35,'Romaine Lettuce - Red Leaf',NULL,'0000000003097','https://www.kroger.com/product/images/large/front/0000000003097','3097');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (36,'Lettuce - Boston Red',NULL,'0000000003098',NULL,'3098');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (37,'Lotus Root',NULL,'0000000003099','https://www.kroger.com/product/images/large/front/0000000003099','3099');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (38,'Honeydew Melon - Golden',NULL,'0000000003100','https://www.kroger.com/product/images/large/front/0000000003100','3100');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (39,'Melons - Camouflage',NULL,'0000000003101','https://www.kroger.com/product/images/large/front/0000000003101','3101');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (40,'Morel Mushrooms',NULL,'0000000003102',NULL,'3102');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (41,'Oranges - Navel - Medium',NULL,'0000000003107','https://www.kroger.com/product/images/large/right/0000000003107','3107');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (42,'Oranges - Valencia - Medium',NULL,'0000000003108',NULL,'3108');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (43,'Oranges - Cara Cara Navels',NULL,'0000000003110','https://www.kroger.com/product/images/small/front/0000000003110','3110');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (44,'Golden Papayas',NULL,'0000000003111','https://www.kroger.com/product/images/small/front/0000000003111','3111');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (45,'Papaya - Red Meridol',NULL,'0000000003112','https://www.kroger.com/product/images/large/front/0000000003112','3112');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (46,'Peaches Doughnut',NULL,'0000000003113','https://www.kroger.com/product/images/large/front/0000000003113','3113');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (47,'Mangoes',NULL,'0000000003114','https://www.kroger.com/product/images/medium/front/0000000003114','3114');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (48,'Peach - Yellow',NULL,'0000000003116','https://www.kroger.com/product/images/large/front/0000000003116','3116');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (49,'Peaches - Yellow',NULL,'0000000003117','https://www.kroger.com/product/images/large/front/0000000003117','3117');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (50,'Red Pears',NULL,'0000000003118',NULL,'3118');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (51,'Green Bell Peppers',NULL,'0000000003120','https://www.kroger.com/product/images/large/front/0000000003120','3120');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (52,'Orange Bell Pepper',NULL,'0000000003121','https://www.kroger.com/product/images/large/front/0000000003121','3121');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (53,'White Holland Bell Peppers',NULL,'0000000003122',NULL,'3122');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (54,'Peppers - Purple Bell',NULL,'0000000003124',NULL,'3124');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (55,'Peppers - Habanero',NULL,'0000000003125','https://www.kroger.com/product/images/large/front/0000000003125','3125');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (56,'Pomegranate',NULL,'0000000003127','https://www.kroger.com/product/images/small/front/0000000003127','3127');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (57,'Potatoes - Purple',NULL,'0000000003128','https://www.kroger.com/product/images/large/front/0000000003128','3128');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (58,'Grapefruit Pummelo',NULL,'0000000003129','https://www.kroger.com/product/images/small/front/0000000003129','3129');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (59,'Pumpkin - Jumbo Bin',NULL,'0000000003130','https://www.kroger.com/product/images/large/front/0000000003130','3130');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (60,'Pumpkins - Painted Pie',NULL,'0000000003131',NULL,'3131');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (61,'Pumpkins - White',NULL,'0000000003132','https://www.kroger.com/product/images/large/front/0000000003132','3132');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (62,'Pie Pumpkins',NULL,'0000000003134','https://www.kroger.com/product/images/large/front/0000000003134','3134');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (63,'Frieda''s Mamey Sapote',NULL,'0000000003137',NULL,'3137');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (64,'Frieda''s Pul Qua Squash',NULL,'0000000003141',NULL,'3141');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (65,'Squash Carnival',NULL,'0000000003142','https://www.kroger.com/product/images/large/front/0000000003142','3142');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (66,'Fallglo Tangerines',NULL,'0000000003144',NULL,'3144');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (67,'On-The-Vine Tomatoes - Yellow',NULL,'0000000003148',NULL,'3148');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (68,'Tomatoes - Orange',NULL,'0000000003149','https://www.kroger.com/product/images/large/front/0000000003149','3149');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (69,'Tomatoes - Red',NULL,'0000000003151','https://www.kroger.com/product/images/large/front/0000000003151','3151');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (70,'Oranges - Valencia',NULL,'0000000003156',NULL,'3156');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (71,'Grapefruit - White - Extra Large',NULL,'0000000003157','https://www.kroger.com/product/images/large/front/0000000003157','3157');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (72,'Extra Large White Grapefruit',NULL,'0000000003159',NULL,'3159');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (73,'Frieda''s Chinese Broccoli',NULL,'0000000003160',NULL,'3160');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (74,'Shanghai Bok Choy',NULL,'0000000003163',NULL,'3163');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (75,'Yu Choy',NULL,'0000000003164',NULL,'3164');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (76,'Treviso Lettuce',NULL,'0000000003165','https://www.kroger.com/product/images/large/front/0000000003165','3165');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (77,'Kale - Tuscan Italian',NULL,'0000000003166',NULL,'3166');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (78,'Yams - White',NULL,'0000000003276',NULL,'3276');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (79,'Broccolini',NULL,'0000000003277','https://www.kroger.com/product/images/large/front/0000000003277','3277');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (80,'Plumcots',NULL,'0000000003278','https://www.kroger.com/product/images/large/front/0000000003278','3278');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (81,'Kiwi - Golden New Zealand',NULL,'0000000003279','https://www.kroger.com/product/images/large/front/0000000003279','3279');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (82,'Honeycrisp Apple',NULL,'0000000003283','https://www.kroger.com/product/images/large/front/0000000003283','3283');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (83,'Apple - Red Delicious - Large',NULL,'0000000003284','https://www.kroger.com/product/images/large/front/0000000003284','3284');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (84,'Apple - Golden Delicious - Extra Large',NULL,'0000000003285','https://www.kroger.com/product/images/large/front/0000000003285','3285');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (85,'Onion - Red - Sweet',NULL,'0000000003286','https://www.kroger.com/product/images/large/front/0000000003286','3286');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (86,'Melon - Sprite',NULL,'0000000003289','https://www.kroger.com/product/images/large/front/0000000003289','3289');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (87,'Southern Rose Apples',NULL,'0000000003290',NULL,'3290');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (88,'Apple - Jazz - Small',NULL,'0000000003293','https://www.kroger.com/product/images/large/front/0000000003293','3293');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (89,'Jazz Large Apples',NULL,'0000000003294','https://www.kroger.com/product/images/large/front/0000000003294','3294');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (90,'Apples Mahana Red',NULL,'0000000003298','https://www.kroger.com/product/images/large/front/0000000003298','3298');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (91,'Apples - Sonya',NULL,'0000000003300',NULL,'3300');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (92,'Red Delicious Apples Bag',NULL,'0000000003302',NULL,'3302');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (93,'Yellow Dragon Fruit',NULL,'0000000003319','https://www.kroger.com/product/images/large/front/0000000003319','3319');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (94,'Broccoli - Romanesco',NULL,'0000000003320','https://www.kroger.com/product/images/large/front/0000000003320','3320');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (95,'Baby Arugula',NULL,'0000000003328',NULL,'3328');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (96,'Baby Spinach',NULL,'0000000003332',NULL,'3332');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (97,'Artichokes -  Red',NULL,'0000000003391',NULL,'3391');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (98,'Lettuce - Red Belgian Endive',NULL,'0000000003395','https://www.kroger.com/product/images/large/front/0000000003395','3395');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (99,'Beans - Garbanzo',NULL,'0000000003398',NULL,'3398');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (100,'Mini Seedless Watermelon',NULL,'0000000003421','https://www.kroger.com/product/images/large/front/0000000003421','3421');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (101,'Apriums',NULL,'0000000003422',NULL,'3422');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (102,'Heirloom Tomatoes',NULL,'0000000003423','https://www.kroger.com/product/images/large/front/0000000003423','3423');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (103,'Carrots',NULL,'0000000003424','https://www.kroger.com/product/images/large/front/0000000003424','3424');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (104,'Apple - Pinata',NULL,'0000000003435','https://www.kroger.com/product/images/large/front/0000000003435','3435');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (105,'Orange Cauliflower',NULL,'0000000003436','https://www.kroger.com/product/images/large/front/0000000003436','3436');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (106,'Nectarines - Flat',NULL,'0000000003437',NULL,'3437');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (107,'Ambrosia Apple',NULL,'0000000003438','https://www.kroger.com/product/images/large/front/0000000003438','3438');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (108,'White Flesh Nectarine',NULL,'0000000003439',NULL,'3439');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (109,'Pomegranate',NULL,'0000000003440','https://www.kroger.com/product/images/large/front/0000000003440','3440');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (110,'Apples - Pazazz',NULL,'0000000003445','https://www.kroger.com/product/images/large/front/0000000003445','3445');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (111,'Yellow Onion Sets',NULL,'0000000003462',NULL,'3462');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (112,'Onions - Red',NULL,'0000000003463','https://www.kroger.com/product/images/large/front/0000000003463','3463');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (113,'Pepper - Aloha',NULL,'0000000003465','https://www.kroger.com/product/images/small/front/0000000003465','3465');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (114,'Mangoes',NULL,'0000000003488','https://www.kroger.com/product/images/large/front/0000000003488','3488');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (115,'Apples - Red - Cosmic Crisp',NULL,'0000000003507','https://www.kroger.com/product/images/large/front/0000000003507','3507');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (116,'Crystal Geyser Alpine Spring Water',NULL,'0000000003516','https://www.kroger.com/product/images/large/front/0000000003516','3516');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (117,'Autumn Glory Apple',NULL,'0000000003601','https://www.kroger.com/product/images/large/front/0000000003601','3601');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (118,'Apple - Sweet Tango',NULL,'0000000003603','https://www.kroger.com/product/images/large/front/0000000003603','3603');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (119,'Apple - Lady Alice',NULL,'0000000003604','https://www.kroger.com/product/images/large/front/0000000003604','3604');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (120,'Kanzi Apples',NULL,'0000000003605','https://www.kroger.com/product/images/large/front/0000000003605','3605');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (121,'Apple - Pacific Rose',NULL,'0000000003608','https://www.kroger.com/product/images/large/front/0000000003608','3608');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (122,'Plumcots',NULL,'0000000003609','https://www.kroger.com/product/images/large/front/0000000003609','3609');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (123,'Plumcots',NULL,'0000000003610','https://www.kroger.com/product/images/large/front/0000000003610','3610');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (124,'Plumcots',NULL,'0000000003611','https://www.kroger.com/product/images/large/front/0000000003611','3611');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (125,'Kiku Apples',NULL,'0000000003613','https://www.kroger.com/product/images/large/front/0000000003613','3613');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (126,'Apples - Envy',NULL,'0000000003616','https://www.kroger.com/product/images/small/front/0000000003616','3616');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (127,'Apple - Opal',NULL,'0000000003618','https://www.kroger.com/product/images/large/front/0000000003618','3618');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (128,'Apples - Jumani',NULL,'0000000003619','https://www.kroger.com/product/images/large/front/0000000003619','3619');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (129,'Apples Koru Euro',NULL,'0000000003620','https://www.kroger.com/product/images/large/front/0000000003620','3620');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (130,'Lemons - Meyer',NULL,'0000000003626',NULL,'3626');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (131,'Pumpkins - Pink',NULL,'0000000003631',NULL,'3631');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (132,'Sumo Citrus',NULL,'0000000003632','https://www.kroger.com/product/images/large/front/0000000003632','3632');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (133,'Bananas',NULL,'0000000004011','https://www.kroger.com/product/images/large/front/0000000004011','4011');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (134,'Navel Oranges - Large',NULL,'0000000004012','https://www.kroger.com/product/images/large/front/0000000004012','4012');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (135,'Navel Oranges',NULL,'0000000004013','https://www.kroger.com/product/images/large/front/0000000004013','4013');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (136,'Oranges - Valencia - Small',NULL,'0000000004014','https://www.kroger.com/product/images/large/front/0000000004014','4014');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (137,'Small Red Delicious Apple',NULL,'0000000004015','https://www.kroger.com/product/images/small/front/0000000004015','4015');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (138,'Large Red Delicious Apples',NULL,'0000000004016','https://www.kroger.com/product/images/small/front/0000000004016','4016');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (139,'Apples - Granny Smith - Large',NULL,'0000000004017','https://www.kroger.com/product/images/large/front/0000000004017','4017');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (140,'Granny Smith Apples',NULL,'0000000004018',NULL,'4018');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (141,'Mcintosh Apples',NULL,'0000000004019','https://www.kroger.com/product/images/large/front/0000000004019','4019');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (142,'Large Golden Delicious Apples',NULL,'0000000004020','https://www.kroger.com/product/images/large/front/0000000004020','4020');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (143,'Small Golden Delicious Apples',NULL,'0000000004021','https://www.kroger.com/product/images/small/front/0000000004021','4021');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (144,'Red Seedless Grapes',NULL,'0000000004023','https://www.kroger.com/product/images/large/front/0000000004023','4023');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (145,'Bartlett Pear',NULL,'0000000004024','https://www.kroger.com/product/images/large/front/0000000004024','4024');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (146,'Anjou Pears - Small',NULL,'0000000004025','https://www.kroger.com/product/images/large/front/0000000004025','4025');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (147,'Pears',NULL,'0000000004026',NULL,'4026');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (148,'Grapefruit - Red',NULL,'0000000004027','https://www.kroger.com/product/images/small/front/0000000004027','4027');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (149,'Strawberries',NULL,'0000000004028','https://www.kroger.com/product/images/large/front/0000000004028','4028');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (150,'Pineapple Small',NULL,'0000000004029','https://www.kroger.com/product/images/large/front/0000000004029','4029');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (151,'Kiwi',NULL,'0000000004030','https://www.kroger.com/product/images/small/front/0000000004030','4030');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (152,'Watermelon - Seeded Red',NULL,'0000000004031','https://www.kroger.com/product/images/large/front/0000000004031','4031');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (153,'Seedless Watermelon',NULL,'0000000004032','https://www.kroger.com/product/images/large/front/0000000004032','4032');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (154,'Lemon - Small',NULL,'0000000004033','https://www.kroger.com/product/images/small/front/0000000004033','4033');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (155,'Melons - Honeydews',NULL,'0000000004034','https://www.kroger.com/product/images/large/right/0000000004034','4034');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (156,'Nectarines',NULL,'0000000004035','https://www.kroger.com/product/images/large/front/0000000004035','4035');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (157,'Nectarines â€" Yellow',NULL,'0000000004036','https://www.kroger.com/product/images/large/front/0000000004036','4036');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (158,'Peaches â€" Yellow â€" Western',NULL,'0000000004038','https://www.kroger.com/product/images/large/front/0000000004038','4038');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (159,'Plums - Black',NULL,'0000000004039','https://www.kroger.com/product/images/large/front/0000000004039','4039');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (160,'Black Plums',NULL,'0000000004040','https://www.kroger.com/product/images/small/front/0000000004040','4040');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (161,'Red Plums - Small',NULL,'0000000004041','https://www.kroger.com/product/images/large/front/0000000004041','4041');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (162,'Red Plums',NULL,'0000000004042','https://www.kroger.com/product/images/small/front/0000000004042','4042');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (163,'Peach - Yellow',NULL,'0000000004044','https://www.kroger.com/product/images/large/front/0000000004044','4044');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (164,'Cherries â€" Red',NULL,'0000000004045','https://www.kroger.com/product/images/large/front/0000000004045','4045');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (165,'Medium Avocado',NULL,'0000000004046','https://www.kroger.com/product/images/large/front/0000000004046','4046');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (166,'Red Small Grapefruit',NULL,'0000000004047',NULL,'4047');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (167,'Large Limes',NULL,'0000000004048','https://www.kroger.com/product/images/small/front/0000000004048','4048');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (168,'Cantaloupe',NULL,'0000000004050','https://www.kroger.com/product/images/large/right/0000000004050','4050');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (169,'Mango - Red - Small',NULL,'0000000004051','https://www.kroger.com/product/images/large/front/0000000004051','4051');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (170,'Papayas',NULL,'0000000004052','https://www.kroger.com/product/images/large/front/0000000004052','4052');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (171,'Lemons',NULL,'0000000004053','https://www.kroger.com/product/images/large/front/0000000004053','4053');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (172,'Raspberries',NULL,'0000000004054','https://www.kroger.com/product/images/large/front/0000000004054','4054');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (173,'Golden Nugget Mandarin',NULL,'0000000004055','https://www.kroger.com/product/images/large/front/0000000004055','4055');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (174,'Black Seedless Grapes',NULL,'0000000004056','https://www.kroger.com/product/images/large/front/0000000004056','4056');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (175,'Bananas',NULL,'0000000004057',NULL,'4057');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (176,'Broccoli',NULL,'0000000004060','https://www.kroger.com/product/images/large/front/0000000004060','4060');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (177,'Iceberg Lettuce',NULL,'0000000004061','https://www.kroger.com/product/images/large/front/0000000004061','4061');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (178,'Cucumber',NULL,'0000000004062','https://www.kroger.com/product/images/large/front/0000000004062','4062');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (179,'Red Tomatoes',NULL,'0000000004063','https://www.kroger.com/product/images/large/front/0000000004063','4063');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (180,'Tomatoes - Vine Ripe - Red',NULL,'0000000004064','https://www.kroger.com/product/images/large/front/0000000004064','4064');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (181,'Large Green Bell Pepper',NULL,'0000000004065','https://www.kroger.com/product/images/large/front/0000000004065','4065');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (182,'Green Beans',NULL,'0000000004066','https://www.kroger.com/product/images/large/front/0000000004066','4066');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (183,'Zucchini',NULL,'0000000004067','https://www.kroger.com/product/images/large/front/0000000004067','4067');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (184,'Green Onions',NULL,'0000000004068','https://www.kroger.com/product/images/small/front/0000000004068','4068');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (185,'Green Cabbage',NULL,'0000000004069','https://www.kroger.com/product/images/large/front/0000000004069','4069');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (186,'Celery',NULL,'0000000004070','https://www.kroger.com/product/images/large/front/0000000004070','4070');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (187,'Celery',NULL,'0000000004071','https://www.kroger.com/product/images/large/front/0000000004071','4071');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (188,'Russet Potato',NULL,'0000000004072','https://www.kroger.com/product/images/small/front/0000000004072','4072');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (189,'Potatoes - Red',NULL,'0000000004073','https://www.kroger.com/product/images/large/front/0000000004073','4073');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (190,'Potatoes - Sweet Yams - Red',NULL,'0000000004074','https://www.kroger.com/product/images/small/front/0000000004074','4074');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (191,'Lettuce - Red Leaf',NULL,'0000000004075','https://www.kroger.com/product/images/large/front/0000000004075','4075');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (192,'Green Leaf Lettuce',NULL,'0000000004076','https://www.kroger.com/product/images/large/front/0000000004076','4076');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (193,'Corn on the Cob - White',NULL,'0000000004077','https://www.kroger.com/product/images/large/front/0000000004077','4077');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (194,'Corn on the Cob',NULL,'0000000004078','https://www.kroger.com/product/images/large/front/0000000004078','4078');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (195,'Cauliflower',NULL,'0000000004079','https://www.kroger.com/product/images/large/front/0000000004079','4079');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (196,'Asparagus',NULL,'0000000004080','https://www.kroger.com/product/images/small/front/0000000004080','4080');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (197,'Eggplant',NULL,'0000000004081','https://www.kroger.com/product/images/large/front/0000000004081','4081');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (198,'Jumbo Red Onions',NULL,'0000000004082','https://www.kroger.com/product/images/large/front/0000000004082','4082');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (199,'Potatoes - White',NULL,'0000000004083','https://www.kroger.com/product/images/large/front/0000000004083','4083');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (200,'Artichoke',NULL,'0000000004084','https://www.kroger.com/product/images/large/right/0000000004084','4084');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (201,'Mushrooms - White - Bulk',NULL,'0000000004085','https://www.kroger.com/product/images/large/front/0000000004085','4085');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (202,'Squash Gold Bar',NULL,'0000000004086','https://www.kroger.com/product/images/large/front/0000000004086','4086');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (203,'Roma Tomato',NULL,'0000000004087','https://www.kroger.com/product/images/small/front/0000000004087','4087');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (204,'Pepper - Bell - Red',NULL,'0000000004088','https://www.kroger.com/product/images/large/front/0000000004088','4088');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (205,'Green Top Red Radishes',NULL,'0000000004089','https://www.kroger.com/product/images/large/front/0000000004089','4089');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (206,'Spinach',NULL,'0000000004090','https://www.kroger.com/product/images/large/front/0000000004090','4090');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (207,'White Yam',NULL,'0000000004091','https://www.kroger.com/product/images/large/front/0000000004091','4091');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (208,'Snow Peas',NULL,'0000000004092','https://www.kroger.com/product/images/large/front/0000000004092','4092');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (209,'Onions - Yellow',NULL,'0000000004093','https://www.kroger.com/product/images/large/front/0000000004093','4093');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (210,'Carrots',NULL,'0000000004094','https://www.kroger.com/product/images/large/front/0000000004094','4094');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (211,'Apples - Large - Ginger Gold',NULL,'0000000004096','https://www.kroger.com/product/images/large/front/0000000004096','4096');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (212,'Apple - Braeburn - Small',NULL,'0000000004101',NULL,'4101');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (213,'Apples - Braeburn',NULL,'0000000004103','https://www.kroger.com/product/images/large/front/0000000004103','4103');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (214,'Apples - Small Red Cortland',NULL,'0000000004104',NULL,'4104');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (215,'Apples - Cortland',NULL,'0000000004106','https://www.kroger.com/product/images/large/front/0000000004106','4106');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (216,'Frieda Crab Apple',NULL,'0000000004107',NULL,'4107');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (217,'Apples - Pacific Rose',NULL,'0000000004122','https://www.kroger.com/product/images/small/front/0000000004122','4122');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (218,'Apples - Small - Empire',NULL,'0000000004124','https://www.kroger.com/product/images/large/front/0000000004124','4124');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (219,'Apples Empire Small',NULL,'0000000004125',NULL,'4125');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (220,'Empire Apples - Large',NULL,'0000000004126',NULL,'4126');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (221,'Apples - Empire',NULL,'0000000004127',NULL,'4127');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (222,'Apples - Extra Small - Pink Cripps',NULL,'0000000004128','https://www.kroger.com/product/images/large/front/0000000004128','4128');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (223,'Small Fuji Apples',NULL,'0000000004129','https://www.kroger.com/product/images/large/front/0000000004129','4129');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (224,'Apple - Pink Cripps - Pink Lady',NULL,'0000000004130','https://www.kroger.com/product/images/large/front/0000000004130','4130');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (225,'Apples - Fuji - Large',NULL,'0000000004131','https://www.kroger.com/product/images/small/front/0000000004131','4131');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (226,'Apples - Gala - Small',NULL,'0000000004132','https://www.kroger.com/product/images/large/back/0000000004132','4132');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (227,'Apple - Gala - Small',NULL,'0000000004133','https://www.kroger.com/product/images/small/front/0000000004133','4133');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (228,'Apples - Gala',NULL,'0000000004134','https://www.kroger.com/product/images/small/front/0000000004134','4134');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (229,'Apple - Gala - Large',NULL,'0000000004135','https://www.kroger.com/product/images/small/front/0000000004135','4135');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (230,'Golden Delicious Apples',NULL,'0000000004136','https://www.kroger.com/product/images/large/front/0000000004136','4136');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (231,'Golden Delicious Apples',NULL,'0000000004137',NULL,'4137');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (232,'Granny Smith Apples',NULL,'0000000004138',NULL,'4138');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (233,'Small Green Granny Smith Apple',NULL,'0000000004139','https://www.kroger.com/product/images/small/front/0000000004139','4139');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (234,'Idared Apples',NULL,'0000000004140',NULL,'4140');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (235,'Apples - Jonamac Small',NULL,'0000000004141',NULL,'4141');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (236,'Apples - Ida Red',NULL,'0000000004142',NULL,'4142');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (237,'Apples - Jonamac',NULL,'0000000004143',NULL,'4143');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (238,'Apples - Jonagold',NULL,'0000000004144',NULL,'4144');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (239,'Jonagold Apples',NULL,'0000000004145',NULL,'4145');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (240,'Apples - Jonagold - Large',NULL,'0000000004146','https://www.kroger.com/product/images/small/front/0000000004146','4146');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (241,'Jonagold Apple',NULL,'0000000004147','https://www.kroger.com/product/images/small/front/0000000004147','4147');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (242,'Jonathan Apples',NULL,'0000000004148',NULL,'4148');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (243,'Ohio Jonathan Apples',NULL,'0000000004149',NULL,'4149');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (244,'Jonathan Apples',NULL,'0000000004150',NULL,'4150');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (245,'Jonathan Apples',NULL,'0000000004151',NULL,'4151');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (246,'Apples - McIntosh',NULL,'0000000004152','https://www.kroger.com/product/images/small/front/0000000004152','4152');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (247,'Apples - McIntosh',NULL,'0000000004153','https://www.kroger.com/product/images/small/front/0000000004153','4153');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (248,'Apples - McIntosh',NULL,'0000000004154','https://www.kroger.com/product/images/small/front/0000000004154','4154');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (249,'Onion - Sweet Vidalia',NULL,'0000000004159','https://www.kroger.com/product/images/small/front/0000000004159','4159');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (250,'Onions - Sweet',NULL,'0000000004161','https://www.kroger.com/product/images/large/front/0000000004161','4161');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (251,'Onions - Sweet - Walla',NULL,'0000000004163','https://www.kroger.com/product/images/large/front/0000000004163','4163');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (252,'Onion - Jumbo - Vidalia',NULL,'0000000004165',NULL,'4165');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (253,'Sweet Onions',NULL,'0000000004166','https://www.kroger.com/product/images/large/front/0000000004166','4166');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (254,'Apples - Delicious Red',NULL,'0000000004167',NULL,'4167');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (255,'Red Delicious Apples',NULL,'0000000004168',NULL,'4168');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (256,'Rome Apples',NULL,'0000000004169',NULL,'4169');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (257,'Rome Apples',NULL,'0000000004171',NULL,'4171');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (258,'Apples Rome',NULL,'0000000004172','https://www.kroger.com/product/images/large/front/0000000004172','4172');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (259,'Gala Euro Apples',NULL,'0000000004173',NULL,'4173');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (260,'New Zealand Gala Apples',NULL,'0000000004174',NULL,'4174');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (261,'Apples Stayman',NULL,'0000000004183','https://www.kroger.com/product/images/large/front/0000000004183','4183');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (262,'Bananas - Baby',NULL,'0000000004186',NULL,'4186');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (263,'Apples Winesap Small',NULL,'0000000004189',NULL,'4189');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (264,'Apples - Winesap - Large',NULL,'0000000004191',NULL,'4191');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (265,'Apples - Winesap',NULL,'0000000004192',NULL,'4192');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (266,'Apricots',NULL,'0000000004218','https://www.kroger.com/product/images/small/front/0000000004218','4218');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (267,'Avocado - Green - Small',NULL,'0000000004221','https://www.kroger.com/product/images/large/front/0000000004221','4221');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (268,'Avocado - FL Lite',NULL,'0000000004223','https://www.kroger.com/product/images/small/front/0000000004223','4223');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (269,'Avocado - Slimcado',NULL,'0000000004224','https://www.kroger.com/product/images/small/front/0000000004224','4224');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (270,'Large Avocado',NULL,'0000000004225','https://www.kroger.com/product/images/large/front/0000000004225','4225');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (271,'Frieda''s Burro Bananas',NULL,'0000000004229','https://www.kroger.com/product/images/large/front/0000000004229','4229');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (272,'Bananas - Manzano',NULL,'0000000004233','https://www.kroger.com/product/images/large/front/0000000004233','4233');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (273,'Bananas - Baby',NULL,'0000000004234',NULL,'4234');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (274,'Banana - Plantains',NULL,'0000000004235','https://www.kroger.com/product/images/large/front/0000000004235','4235');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (275,'Banana - Red',NULL,'0000000004236','https://www.kroger.com/product/images/large/front/0000000004236','4236');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (276,'Blackberries',NULL,'0000000004239','https://www.kroger.com/product/images/large/front/0000000004239','4239');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (277,'Blueberries',NULL,'0000000004240','https://www.kroger.com/product/images/large/front/0000000004240','4240');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (278,'Strawberries',NULL,'0000000004247','https://www.kroger.com/product/images/large/front/0000000004247','4247');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (279,'Prickly Cactus Pear',NULL,'0000000004255','https://www.kroger.com/product/images/small/front/0000000004255','4255');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (280,'Starfruit',NULL,'0000000004256','https://www.kroger.com/product/images/large/front/0000000004256','4256');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (281,'Cherimoya',NULL,'0000000004257',NULL,'4257');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (282,'Cherries â€" Rainier',NULL,'0000000004258','https://www.kroger.com/product/images/large/front/0000000004258','4258');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (283,'Coconuts in Husk',NULL,'0000000004260','https://www.kroger.com/product/images/large/front/0000000004260','4260');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (284,'Coconut',NULL,'0000000004261','https://www.kroger.com/product/images/large/front/0000000004261','4261');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (285,'Feijoa',NULL,'0000000004265',NULL,'4265');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (286,'Dried Figs',NULL,'0000000004267',NULL,'4267');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (287,'Grapes - Red Globe',NULL,'0000000004273',NULL,'4273');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (288,'White Pummelos',NULL,'0000000004279',NULL,'4279');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (289,'Small Red Grapefruit',NULL,'0000000004280',NULL,'4280');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (290,'Grapefruit - Red - Large',NULL,'0000000004281','https://www.kroger.com/product/images/small/front/0000000004281','4281');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (291,'Grapefruit - Pink',NULL,'0000000004282','https://www.kroger.com/product/images/large/front/0000000004282','4282');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (292,'Grapefruit',NULL,'0000000004283',NULL,'4283');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (293,'Grapefruit - Red',NULL,'0000000004284','https://www.kroger.com/product/images/large/front/0000000004284','4284');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (294,'Rio Grapefruit',NULL,'0000000004285',NULL,'4285');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (295,'Rio Grapefruit',NULL,'0000000004286',NULL,'4286');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (296,'Red Rio Star Grapefruit',NULL,'0000000004287',NULL,'4287');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (297,'Grapefruit - Ruby Red',NULL,'0000000004288','https://www.kroger.com/product/images/large/front/0000000004288','4288');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (298,'Grapefruit - Deep Red - Large',NULL,'0000000004289','https://www.kroger.com/product/images/large/front/0000000004289','4289');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (299,'White Grapefruit',NULL,'0000000004290','https://www.kroger.com/product/images/large/front/0000000004290','4290');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (300,'Grapefruit - White - Large',NULL,'0000000004293','https://www.kroger.com/product/images/large/front/0000000004293','4293');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (301,'Grapefruit - White Large',NULL,'0000000004294','https://www.kroger.com/product/images/large/front/0000000004294','4294');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (302,'Grapefruit - Large White',NULL,'0000000004295',NULL,'4295');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (303,'Guava',NULL,'0000000004299','https://www.kroger.com/product/images/large/front/0000000004299','4299');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (304,'Jamacian Tangelo',NULL,'0000000004300',NULL,'4300');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (305,'Melons - Horned - Kiwano',NULL,'0000000004302','https://www.kroger.com/product/images/large/front/0000000004302','4302');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (306,'Kumquat',NULL,'0000000004303',NULL,'4303');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (307,'Limes - Key',NULL,'0000000004305','https://www.kroger.com/product/images/small/front/0000000004305','4305');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (308,'Lychee',NULL,'0000000004309',NULL,'4309');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (309,'Mango - Keitt',NULL,'0000000004311','https://www.kroger.com/product/images/small/front/0000000004311','4311');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (310,'Mangoes - Honey',NULL,'0000000004312','https://www.kroger.com/product/images/large/front/0000000004312','4312');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (311,'Melons - Canary',NULL,'0000000004317','https://www.kroger.com/product/images/large/front/0000000004317','4317');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (312,'Athena Cantaloupe',NULL,'0000000004318',NULL,'4318');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (313,'Athena Cantaloupe',NULL,'0000000004319','https://www.kroger.com/product/images/large/front/0000000004319','4319');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (314,'Casaba Melons',NULL,'0000000004320','https://www.kroger.com/product/images/large/front/0000000004320','4320');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (315,'Crenshaw Melons',NULL,'0000000004322','https://www.kroger.com/product/images/large/front/0000000004322','4322');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (316,'Strawberries Bulk',NULL,'0000000004323',NULL,'4323');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (317,'Melons - Galia',NULL,'0000000004326','https://www.kroger.com/product/images/large/front/0000000004326','4326');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (318,'Honeydew Melon',NULL,'0000000004327','https://www.kroger.com/product/images/large/front/0000000004327','4327');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (319,'Honeydew Melon - Small',NULL,'0000000004329','https://www.kroger.com/product/images/large/front/0000000004329','4329');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (320,'Watermelon',NULL,'0000000004331','https://www.kroger.com/product/images/large/front/0000000004331','4331');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (321,'Cantaloupe',NULL,'0000000004332',NULL,'4332');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (322,'Melons - Pepino',NULL,'0000000004333','https://www.kroger.com/product/images/large/front/0000000004333','4333');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (323,'Melons - Persian',NULL,'0000000004334',NULL,'4334');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (324,'Melons - Santa Claus',NULL,'0000000004336',NULL,'4336');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (325,'Watermelon Yellow',NULL,'0000000004340',NULL,'4340');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (326,'Yellow Seedless Watermelon',NULL,'0000000004341',NULL,'4341');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (327,'In-Store Cut Watermelon Halves',NULL,'0000000004343',NULL,'4343');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (328,'Seedless Watermelon Halves',NULL,'0000000004351',NULL,'4351');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (329,'Cantaloupe Cube Large Cup',NULL,'0000000004358','https://www.kroger.com/product/images/large/front/0000000004358','4358');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (330,'Cut Honeydew',NULL,'0000000004359','https://www.kroger.com/product/images/large/front/0000000004359','4359');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (331,'In-Store Cut Canary Melon Halves',NULL,'0000000004360',NULL,'4360');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (332,'Cantaloupe - Tuscan',NULL,'0000000004362',NULL,'4362');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (333,'In-Store Cut Mixed Melons Large Cup',NULL,'0000000004363',NULL,'4363');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (334,'Watermelon - Seeded - 1/8',NULL,'0000000004367','https://www.kroger.com/product/images/large/front/0000000004367','4367');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (335,'Cantaloupe -  1/2',NULL,'0000000004368','https://www.kroger.com/product/images/small/front/0000000004368','4368');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (336,'Honeydew Melon Half',NULL,'0000000004369','https://www.kroger.com/product/images/large/front/0000000004369','4369');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (337,'Temptation Melons',NULL,'0000000004371',NULL,'4371');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (338,'Watermelon - Orange Meat Bin',NULL,'0000000004373','https://www.kroger.com/product/images/large/front/0000000004373','4373');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (339,'In-Store Cut Halved Persian Melon',NULL,'0000000004374',NULL,'4374');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (340,'Yellow Nectarines',NULL,'0000000004376','https://www.kroger.com/product/images/large/front/0000000004376','4376');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (341,'Nectarines',NULL,'0000000004377',NULL,'4377');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (342,'Chile Nectarines',NULL,'0000000004378','https://www.kroger.com/product/images/large/front/0000000004378','4378');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (343,'Blood Oranges',NULL,'0000000004381','https://www.kroger.com/product/images/large/front/0000000004381','4381');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (344,'Tangelo - Minneola',NULL,'0000000004383','https://www.kroger.com/product/images/large/front/0000000004383','4383');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (345,'Oranges - Small Navel',NULL,'0000000004384',NULL,'4384');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (346,'Oranges Navels',NULL,'0000000004385',NULL,'4385');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (347,'Oranges - Temple',NULL,'0000000004387','https://www.kroger.com/product/images/large/front/0000000004387','4387');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (348,'Large Valencia Oranges',NULL,'0000000004388',NULL,'4388');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (349,'Papayas',NULL,'0000000004394','https://www.kroger.com/product/images/large/front/0000000004394','4394');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (350,'Mexican Papayas',NULL,'0000000004395','https://www.kroger.com/product/images/large/front/0000000004395','4395');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (351,'Passion Fruit',NULL,'0000000004397','https://www.kroger.com/product/images/large/front/0000000004397','4397');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (352,'Peach - White',NULL,'0000000004401','https://www.kroger.com/product/images/large/front/0000000004401','4401');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (353,'Peach - Yellow',NULL,'0000000004402','https://www.kroger.com/product/images/large/front/0000000004402','4402');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (354,'Peach - Yellow',NULL,'0000000004403','https://www.kroger.com/product/images/large/front/0000000004403','4403');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (355,'Asian Pear',NULL,'0000000004406','https://www.kroger.com/product/images/medium/front/0000000004406','4406');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (356,'Asian Pears',NULL,'0000000004407','https://www.kroger.com/product/images/small/front/0000000004407','4407');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (357,'Asian Pear',NULL,'0000000004408','https://www.kroger.com/product/images/small/front/0000000004408','4408');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (358,'Pear - Bartlett',NULL,'0000000004409','https://www.kroger.com/product/images/large/front/0000000004409','4409');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (359,'Pears - Red',NULL,'0000000004410','https://www.kroger.com/product/images/large/front/0000000004410','4410');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (360,'Bosc Pears',NULL,'0000000004412',NULL,'4412');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (361,'Pear - Bosc',NULL,'0000000004413','https://www.kroger.com/product/images/small/front/0000000004413','4413');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (362,'Comice Pears',NULL,'0000000004414','https://www.kroger.com/product/images/large/front/0000000004414','4414');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (363,'Pears - Red',NULL,'0000000004415','https://www.kroger.com/product/images/large/front/0000000004415','4415');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (364,'Pears - Anjou - Large',NULL,'0000000004416','https://www.kroger.com/product/images/small/front/0000000004416','4416');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (365,'Pears - Red Anjou',NULL,'0000000004417','https://www.kroger.com/product/images/small/front/0000000004417','4417');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (366,'Forelle Pear',NULL,'0000000004418','https://www.kroger.com/product/images/large/front/0000000004418','4418');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (367,'Pear - French Butter',NULL,'0000000004419','https://www.kroger.com/product/images/large/front/0000000004419','4419');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (368,'Pear - Packham',NULL,'0000000004421',NULL,'4421');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (369,'Pears - Seckel',NULL,'0000000004422','https://www.kroger.com/product/images/large/front/0000000004422','4422');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (370,'Hachiya - Persimmon',NULL,'0000000004427','https://www.kroger.com/product/images/large/front/0000000004427','4427');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (371,'Persimmon',NULL,'0000000004428','https://www.kroger.com/product/images/small/front/0000000004428','4428');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (372,'Pineapple - Gold',NULL,'0000000004430','https://www.kroger.com/product/images/small/front/0000000004430','4430');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (373,'Pineapple - Gold',NULL,'0000000004431','https://www.kroger.com/product/images/large/front/0000000004431','4431');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (374,'Italian Plums',NULL,'0000000004436',NULL,'4436');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (375,'Plums - Red Chilean',NULL,'0000000004440','https://www.kroger.com/product/images/small/front/0000000004440','4440');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (376,'Golden 2 Layer Plums',NULL,'0000000004441',NULL,'4441');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (377,'Yellow Plums',NULL,'0000000004442',NULL,'4442');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (378,'Pomegranate - Small',NULL,'0000000004445','https://www.kroger.com/product/images/large/front/0000000004445','4445');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (379,'Quince',NULL,'0000000004447','https://www.kroger.com/product/images/large/front/0000000004447','4447');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (380,'Tamarind',NULL,'0000000004448','https://www.kroger.com/product/images/large/front/0000000004448','4448');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (381,'Seedless Clementines',NULL,'0000000004450','https://www.kroger.com/product/images/large/front/0000000004450','4450');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (382,'Tangerines - Dancy',NULL,'0000000004451',NULL,'4451');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (383,'Tangerines - Fairchild',NULL,'0000000004452','https://www.kroger.com/product/images/large/front/0000000004452','4452');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (384,'Tangerines - Gold Nugget',NULL,'0000000004453','https://www.kroger.com/product/images/large/front/0000000004453','4453');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (385,'Tangelos',NULL,'0000000004456',NULL,'4456');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (386,'Jamaican Tangelo',NULL,'0000000004459','https://www.kroger.com/product/images/large/front/0000000004459','4459');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (387,'Salad Bar',NULL,'0000000004470',NULL,'4470');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (388,'Ruby Red Grapefruit - Extra Large',NULL,'0000000004491','https://www.kroger.com/product/images/large/front/0000000004491','4491');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (389,'Grapefruit - Red',NULL,'0000000004492','https://www.kroger.com/product/images/large/front/0000000004492','4492');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (390,'Red Grapefruit',NULL,'0000000004493','https://www.kroger.com/product/images/small/front/0000000004493','4493');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (391,'Grapefruit - Red Extra Large',NULL,'0000000004494','https://www.kroger.com/product/images/large/front/0000000004494','4494');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (392,'Ruby Red Extra Large Grapefruit',NULL,'0000000004495','https://www.kroger.com/product/images/small/front/0000000004495','4495');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (393,'Texas Rio Star Ruby Red Extra Large Grapefruit',NULL,'0000000004496','https://www.kroger.com/product/images/thumbnail/front/0000000004496','4496');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (394,'Grapes - Chilean Perlette',NULL,'0000000004497','https://www.kroger.com/product/images/large/front/0000000004497','4497');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (395,'Grapes - White',NULL,'0000000004498','https://www.kroger.com/product/images/large/front/0000000004498','4498');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (396,'Grapes - Red Seedless',NULL,'0000000004499','https://www.kroger.com/product/images/large/front/0000000004499','4499');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (397,'Fennel',NULL,'0000000004515','https://www.kroger.com/product/images/large/front/0000000004515','4515');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (398,'Long Stem Artichoke',NULL,'0000000004518',NULL,'4518');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (399,'Artichokes - Baby Purple',NULL,'0000000004519',NULL,'4519');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (400,'Asparagus - White',NULL,'0000000004522','https://www.kroger.com/product/images/large/front/0000000004522','4522');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (401,'White Asparagus',NULL,'0000000004523','https://www.kroger.com/product/images/large/front/0000000004523','4523');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (402,'Frieda''s Chinese Long Beans',NULL,'0000000004527','https://www.kroger.com/product/images/large/front/0000000004527','4527');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (403,'Fava Beans',NULL,'0000000004528',NULL,'4528');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (404,'Pole Beans',NULL,'0000000004530','https://www.kroger.com/product/images/large/front/0000000004530','4530');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (405,'Frieda''s Purple Wax Beans',NULL,'0000000004531',NULL,'4531');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (406,'Sea Beans',NULL,'0000000004532',NULL,'4532');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (407,'Beans - Wax - Yellow',NULL,'0000000004533','https://www.kroger.com/product/images/large/front/0000000004533','4533');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (408,'Beets - Red',NULL,'0000000004537','https://www.kroger.com/product/images/large/front/0000000004537','4537');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (409,'Beets - Red - Baby',NULL,'0000000004538','https://www.kroger.com/product/images/large/front/0000000004538','4538');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (410,'Beets',NULL,'0000000004539','https://www.kroger.com/product/images/large/front/0000000004539','4539');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (411,'Beets - Loose',NULL,'0000000004540','https://www.kroger.com/product/images/large/front/0000000004540','4540');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (412,'Lettuce - Endive - Belgium',NULL,'0000000004543','https://www.kroger.com/product/images/large/front/0000000004543','4543');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (413,'Bok Choy - Baby',NULL,'0000000004544','https://www.kroger.com/product/images/large/front/0000000004544','4544');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (414,'Bok Choy',NULL,'0000000004545','https://www.kroger.com/product/images/large/front/0000000004545','4545');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (415,'Rapini Greens',NULL,'0000000004547','https://www.kroger.com/product/images/large/front/0000000004547','4547');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (416,'Broccoli Crowns',NULL,'0000000004548','https://www.kroger.com/product/images/large/front/0000000004548','4548');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (417,'Brussels Sprouts',NULL,'0000000004550','https://www.kroger.com/product/images/large/front/0000000004550','4550');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (418,'Napa Cabbage',NULL,'0000000004552','https://www.kroger.com/product/images/large/front/0000000004552','4552');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (419,'Taylor Gold Pears',NULL,'0000000004553',NULL,'4553');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (420,'Cabbage - Red',NULL,'0000000004554','https://www.kroger.com/product/images/large/front/0000000004554','4554');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (421,'Cabbage - Savoy',NULL,'0000000004555','https://www.kroger.com/product/images/small/front/0000000004555','4555');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (422,'Leaf Green Cactus',NULL,'0000000004558',NULL,'4558');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (423,'Cardoon',NULL,'0000000004559',NULL,'4559');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (424,'Carrots - Baby - Rainbow',NULL,'0000000004560','https://www.kroger.com/product/images/large/front/0000000004560','4560');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (425,'French Carrots',NULL,'0000000004561',NULL,'4561');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (426,'Carrot',NULL,'0000000004562','https://www.kroger.com/product/images/large/front/0000000004562','4562');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (427,'Cauliflower Florets',NULL,'0000000004566',NULL,'4566');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (428,'Broccoflower',NULL,'0000000004567','https://www.kroger.com/product/images/large/front/0000000004567','4567');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (429,'Cauliflower - Purple',NULL,'0000000004568','https://www.kroger.com/product/images/large/front/0000000004568','4568');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (430,'Cauliflower - Whole',NULL,'0000000004572','https://www.kroger.com/product/images/large/front/0000000004572','4572');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (431,'Cauliflower - Baby',NULL,'0000000004573',NULL,'4573');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (432,'Celery Hearts',NULL,'0000000004575','https://www.kroger.com/product/images/large/front/0000000004575','4575');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (433,'Celery Sticks',NULL,'0000000004576','https://www.kroger.com/product/images/large/front/0000000004576','4576');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (434,'Celery',NULL,'0000000004582',NULL,'4582');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (435,'Celery',NULL,'0000000004583','https://www.kroger.com/product/images/large/front/0000000004583','4583');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (436,'Mango Green',NULL,'0000000004584','https://www.kroger.com/product/images/large/front/0000000004584','4584');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (437,'Celery Root - Bulk',NULL,'0000000004585','https://www.kroger.com/product/images/large/front/0000000004585','4585');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (438,'Chard Greens',NULL,'0000000004586','https://www.kroger.com/product/images/large/front/0000000004586','4586');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (439,'Chard Red Bunch',NULL,'0000000004587',NULL,'4587');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (440,'Corn - Baby in Husk',NULL,'0000000004589',NULL,'4589');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (441,'Corn on the Cob - Bi-Color',NULL,'0000000004590','https://www.kroger.com/product/images/large/front/0000000004590','4590');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (442,'Cucumber - Persian',NULL,'0000000004592','https://www.kroger.com/product/images/large/front/0000000004592','4592');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (443,'Cucumber - English',NULL,'0000000004593','https://www.kroger.com/product/images/large/front/0000000004593','4593');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (444,'Cucumbers - Japanese',NULL,'0000000004594',NULL,'4594');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (445,'Pickling Cucumbers',NULL,'0000000004596',NULL,'4596');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (446,'Daikon',NULL,'0000000004598','https://www.kroger.com/product/images/large/front/0000000004598','4598');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (447,'Eggplant - Baby',NULL,'0000000004599','https://www.kroger.com/product/images/large/front/0000000004599','4599');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (448,'Frieda''s Japanese Eggplant',NULL,'0000000004601',NULL,'4601');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (449,'Eggplant - White',NULL,'0000000004602','https://www.kroger.com/product/images/large/front/0000000004602','4602');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (450,'Lettuce - Endive',NULL,'0000000004604','https://www.kroger.com/product/images/large/front/0000000004604','4604');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (451,'Lettuce - Escarole',NULL,'0000000004605','https://www.kroger.com/product/images/large/front/0000000004605','4605');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (452,'Gai Choy',NULL,'0000000004607',NULL,'4607');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (453,'Garlic',NULL,'0000000004608','https://www.kroger.com/product/images/large/front/0000000004608','4608');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (454,'Elephant Garlic',NULL,'0000000004609','https://www.kroger.com/product/images/large/front/0000000004609','4609');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (455,'Ginger Root',NULL,'0000000004612','https://www.kroger.com/product/images/large/front/0000000004612','4612');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (456,'Collard Greens Bunch',NULL,'0000000004614','https://www.kroger.com/product/images/large/front/0000000004614','4614');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (457,'Freida Dandelion Green',NULL,'0000000004615','https://www.kroger.com/product/images/large/front/0000000004615','4615');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (458,'Greens - Curly Mustard',NULL,'0000000004616','https://www.kroger.com/product/images/large/front/0000000004616','4616');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (459,'Flat Mustard Greens',NULL,'0000000004618','https://www.kroger.com/product/images/large/front/0000000004618','4618');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (460,'Greens -  Turnip',NULL,'0000000004619','https://www.kroger.com/product/images/large/front/0000000004619','4619');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (461,'Horseradish Root',NULL,'0000000004625','https://www.kroger.com/product/images/thumbnail/front/0000000004625','4625');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (462,'Jicama',NULL,'0000000004626','https://www.kroger.com/product/images/large/front/0000000004626','4626');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (463,'Greens -  Kale',NULL,'0000000004627','https://www.kroger.com/product/images/large/front/0000000004627','4627');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (464,'Kohlrabi Lettuce',NULL,'0000000004628','https://www.kroger.com/product/images/large/front/0000000004628','4628');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (465,'Leeks',NULL,'0000000004629','https://www.kroger.com/product/images/large/front/0000000004629','4629');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (466,'Leeks - Baby',NULL,'0000000004630','https://www.kroger.com/product/images/large/front/0000000004630','4630');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (467,'Lettuce - Bibb',NULL,'0000000004631','https://www.kroger.com/product/images/large/front/0000000004631','4631');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (468,'Lettuce - Boston',NULL,'0000000004632','https://www.kroger.com/product/images/large/front/0000000004632','4632');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (469,'Lettuce - Bibb Hydroponic',NULL,'0000000004633','https://www.kroger.com/product/images/large/front/0000000004633','4633');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (470,'Lettuce - Iceberg Wraps',NULL,'0000000004634','https://www.kroger.com/product/images/large/front/0000000004634','4634');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (471,'Grapes - Red - Seedless - Sold by the Bag - Estimated Bag Weight 2 Pounds',NULL,'0000000004635','https://www.kroger.com/product/images/large/front/0000000004635','4635');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (472,'Grapes - Red Globe - Seeded - Sold by the Bag - Estimated Bag Weight 2 Pounds',NULL,'0000000004636','https://www.kroger.com/product/images/large/front/0000000004636','4636');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (473,'Grapes - Red - Seeded',NULL,'0000000004637','https://www.kroger.com/product/images/large/front/0000000004637','4637');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (474,'Lettuce - Romaine',NULL,'0000000004640','https://www.kroger.com/product/images/large/front/0000000004640','4640');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (475,'Malanga',NULL,'0000000004644',NULL,'4644');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (476,'Small White Mushrooms',NULL,'0000000004645',NULL,'4645');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (477,'Black Forest Trumpet Mushrooms',NULL,'0000000004646',NULL,'4646');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (478,'Mushrooms - Chanterelle',NULL,'0000000004647','https://www.kroger.com/product/images/large/front/0000000004647','4647');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (479,'Mushrooms - Crimini - Bulk',NULL,'0000000004648','https://www.kroger.com/product/images/large/front/0000000004648','4648');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (480,'Mushrooms - Oyster',NULL,'0000000004649','https://www.kroger.com/product/images/large/front/0000000004649','4649');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (481,'Mushrooms - Portabella - Bulk',NULL,'0000000004650','https://www.kroger.com/product/images/large/front/0000000004650','4650');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (482,'Mushrooms - Shiitake - Bulk',NULL,'0000000004651','https://www.kroger.com/product/images/large/front/0000000004651','4651');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (483,'Mushrooms  Woodear',NULL,'0000000004652','https://www.kroger.com/product/images/large/front/0000000004652','4652');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (484,'Okra',NULL,'0000000004655','https://www.kroger.com/product/images/large/front/0000000004655','4655');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (485,'Okra - Chinese',NULL,'0000000004656','https://www.kroger.com/product/images/large/front/0000000004656','4656');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (486,'Red Pearl Onions',NULL,'0000000004658',NULL,'4658');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (487,'Green Onions',NULL,'0000000004659','https://www.kroger.com/product/images/large/front/0000000004659','4659');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (488,'Gold Pearl Onions',NULL,'0000000004660',NULL,'4660');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (489,'Onions - Shallot',NULL,'0000000004662','https://www.kroger.com/product/images/large/front/0000000004662','4662');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (490,'White Onions',NULL,'0000000004663','https://www.kroger.com/product/images/small/front/0000000004663','4663');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (491,'On The Vine Tomatoes (4-5 Tomatoes per Bunch)',NULL,'0000000004664','https://www.kroger.com/product/images/large/front/0000000004664','4664');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (492,'Onions - Yellow - Small',NULL,'0000000004665','https://www.kroger.com/product/images/large/front/0000000004665','4665');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (493,'Roots - Parsley',NULL,'0000000004671','https://www.kroger.com/product/images/large/front/0000000004671','4671');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (494,'Parsnip',NULL,'0000000004672','https://www.kroger.com/product/images/large/front/0000000004672','4672');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (495,'English Green Peas',NULL,'0000000004674','https://www.kroger.com/product/images/large/front/0000000004674','4674');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (496,'Peas- Sugar Snap',NULL,'0000000004675','https://www.kroger.com/product/images/large/front/0000000004675','4675');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (497,'Anaheim Peppers',NULL,'0000000004677','https://www.kroger.com/product/images/large/front/0000000004677','4677');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (498,'Peppers - Yellow Banana',NULL,'0000000004678','https://www.kroger.com/product/images/large/front/0000000004678','4678');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (499,'Bell Pepper - Yellow',NULL,'0000000004680','https://www.kroger.com/product/images/large/front/0000000004680','4680');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (500,'Green Bell Peppers',NULL,'0000000004681','https://www.kroger.com/product/images/large/front/0000000004681','4681');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (501,'Pepper - Bell - Orange',NULL,'0000000004682','https://www.kroger.com/product/images/large/front/0000000004682','4682');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (502,'Purple Bell Peppers',NULL,'0000000004683',NULL,'4683');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (503,'White Bell Peppers',NULL,'0000000004684',NULL,'4684');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (504,'Pepper Hot Chili',NULL,'0000000004686','https://www.kroger.com/product/images/large/front/0000000004686','4686');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (505,'Peppers -Chile Cubanelle',NULL,'0000000004687',NULL,'4687');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (506,'Red Bell Pepper',NULL,'0000000004688','https://www.kroger.com/product/images/large/front/0000000004688','4688');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (507,'Bell Pepper - Yellow',NULL,'0000000004689','https://www.kroger.com/product/images/large/front/0000000004689','4689');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (508,'Chili Pepper',NULL,'0000000004691','https://www.kroger.com/product/images/large/front/0000000004691','4691');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (509,'Yellow Hungarian Peppers',NULL,'0000000004692','https://www.kroger.com/product/images/large/front/0000000004692','4692');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (510,'Jalapeno Peppers',NULL,'0000000004693','https://www.kroger.com/product/images/small/front/0000000004693','4693');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (511,'Pepper - Jalapeno - Red',NULL,'0000000004694','https://www.kroger.com/product/images/large/front/0000000004694','4694');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (512,'Long Green Peppers',NULL,'0000000004696',NULL,'4696');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (513,'Peppers - Red - Long',NULL,'0000000004697','https://www.kroger.com/product/images/large/front/0000000004697','4697');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (514,'Chile - Red',NULL,'0000000004698',NULL,'4698');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (515,'Peppers - Hatch',NULL,'0000000004700','https://www.kroger.com/product/images/large/front/0000000004700','4700');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (516,'Peppers - Chilaca',NULL,'0000000004701','https://www.kroger.com/product/images/large/front/0000000004701','4701');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (517,'Red Pasilla Chile',NULL,'0000000004702','https://www.kroger.com/product/images/large/front/0000000004702','4702');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (518,'Mico Pasilla Chile Pods',NULL,'0000000004703',NULL,'4703');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (519,'Peppers -  Poblano',NULL,'0000000004705','https://www.kroger.com/product/images/large/front/0000000004705','4705');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (520,'Peppers Hot',NULL,'0000000004707','https://www.kroger.com/product/images/large/front/0000000004707','4707');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (521,'Peppers - Serrano - Green',NULL,'0000000004709','https://www.kroger.com/product/images/large/front/0000000004709','4709');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (522,'Potatoes - Red - Creamer',NULL,'0000000004723','https://www.kroger.com/product/images/large/front/0000000004723','4723');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (523,'Potatoes - White - Creamer',NULL,'0000000004724','https://www.kroger.com/product/images/large/front/0000000004724','4724');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (524,'Potatoes - Idaho Baking',NULL,'0000000004725',NULL,'4725');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (525,'Potatoes - White',NULL,'0000000004726',NULL,'4726');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (526,'Yukon Potatoes - Gold',NULL,'0000000004727','https://www.kroger.com/product/images/large/front/0000000004727','4727');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (527,'Pumpkins - Mini (Up to 1 lb)',NULL,'0000000004734','https://www.kroger.com/product/images/large/front/0000000004734','4734');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (528,'Pumpkins - Medium (Up to 13 lbs)',NULL,'0000000004735','https://www.kroger.com/product/images/small/front/0000000004735','4735');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (529,'Radicchio Lettuce',NULL,'0000000004738','https://www.kroger.com/product/images/large/front/0000000004738','4738');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (530,'Radishes',NULL,'0000000004739','https://www.kroger.com/product/images/large/front/0000000004739','4739');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (531,'Radishes - Red Mini Italian',NULL,'0000000004741',NULL,'4741');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (532,'Radishes Red Bulk',NULL,'0000000004742','https://www.kroger.com/product/images/small/front/0000000004742','4742');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (533,'Icicle Bunch Radishes',NULL,'0000000004743',NULL,'4743');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (534,'Rhubarb',NULL,'0000000004745','https://www.kroger.com/product/images/large/front/0000000004745','4745');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (535,'Rutabagas',NULL,'0000000004747','https://www.kroger.com/product/images/large/front/0000000004747','4747');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (536,'Squash - Green - Acorn',NULL,'0000000004750','https://www.kroger.com/product/images/large/front/0000000004750','4750');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (537,'Squash -  Acorn Golden',NULL,'0000000004751','https://www.kroger.com/product/images/large/front/0000000004751','4751');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (538,'Squash - Acorn White',NULL,'0000000004752','https://www.kroger.com/product/images/large/front/0000000004752','4752');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (539,'Squash - Baby Summer',NULL,'0000000004755',NULL,'4755');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (540,'Zucchini Squash - Baby',NULL,'0000000004756','https://www.kroger.com/product/images/large/front/0000000004756','4756');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (541,'Banana Squash',NULL,'0000000004757','https://www.kroger.com/product/images/large/front/0000000004757','4757');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (542,'Squash -  Buttercup',NULL,'0000000004758','https://www.kroger.com/product/images/large/front/0000000004758','4758');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (543,'Squash - Butternut',NULL,'0000000004759','https://www.kroger.com/product/images/large/front/0000000004759','4759');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (544,'Squash -  Calabaza',NULL,'0000000004760',NULL,'4760');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (545,'Chayote Squash',NULL,'0000000004761','https://www.kroger.com/product/images/small/front/0000000004761','4761');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (546,'Artichoke',NULL,'0000000004762','https://www.kroger.com/product/images/large/front/0000000004762','4762');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (547,'Frieda''s Squash Delicata',NULL,'0000000004763','https://www.kroger.com/product/images/large/front/0000000004763','4763');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (548,'Squash',NULL,'0000000004764','https://www.kroger.com/product/images/large/front/0000000004764','4764');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (549,'Squash - Golden Nugget',NULL,'0000000004767','https://www.kroger.com/product/images/large/front/0000000004767','4767');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (550,'Squash - Golden Hubbard',NULL,'0000000004768','https://www.kroger.com/product/images/large/front/0000000004768','4768');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (551,'Squash - Kabocha',NULL,'0000000004769','https://www.kroger.com/product/images/large/front/0000000004769','4769');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (552,'Avocado - Extra Large',NULL,'0000000004770','https://www.kroger.com/product/images/large/front/0000000004770','4770');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (553,'Avocado - Medium',NULL,'0000000004771','https://www.kroger.com/product/images/large/front/0000000004771','4771');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (554,'Chile Yellow',NULL,'0000000004772','https://www.kroger.com/product/images/large/front/0000000004772','4772');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (555,'Summer Squash',NULL,'0000000004773',NULL,'4773');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (556,'Frieda''s Red Kuri Squash',NULL,'0000000004774',NULL,'4774');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (557,'Squash -  Spaghetti',NULL,'0000000004776','https://www.kroger.com/product/images/large/front/0000000004776','4776');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (558,'Squash - Sunburst',NULL,'0000000004777',NULL,'4777');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (559,'Yellow Tomatoes',NULL,'0000000004778',NULL,'4778');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (560,'Squash - Sweet Mama',NULL,'0000000004779',NULL,'4779');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (561,'Squash -  Turban',NULL,'0000000004780',NULL,'4780');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (562,'Squash - White',NULL,'0000000004781','https://www.kroger.com/product/images/large/front/0000000004781','4781');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (563,'Squash - Yellow',NULL,'0000000004782','https://www.kroger.com/product/images/large/front/0000000004782','4782');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (564,'Gourd - Foo Qua Bitter',NULL,'0000000004783',NULL,'4783');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (565,'Squash Yellow',NULL,'0000000004784','https://www.kroger.com/product/images/large/front/0000000004784','4784');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (566,'Sunchokes',NULL,'0000000004791','https://www.kroger.com/product/images/large/front/0000000004791','4791');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (567,'Frieda''s Gold Tamarillo',NULL,'0000000004792',NULL,'4792');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (568,'Tamarillo - Red',NULL,'0000000004793',NULL,'4793');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (569,'Taro Root',NULL,'0000000004794',NULL,'4794');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (570,'Large Tarro Root',NULL,'0000000004795',NULL,'4795');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (571,'Tomato - Red - Cherry',NULL,'0000000004796','https://www.kroger.com/product/images/large/front/0000000004796','4796');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (572,'Medium Red Tomatoes',NULL,'0000000004798',NULL,'4798');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (573,'Tomatoes - Red',NULL,'0000000004799','https://www.kroger.com/product/images/large/front/0000000004799','4799');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (574,'Tomatoes - Red',NULL,'0000000004800','https://www.kroger.com/product/images/large/front/0000000004800','4800');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (575,'Tomatillo',NULL,'0000000004801','https://www.kroger.com/product/images/large/front/0000000004801','4801');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (576,'Tomatoes Red Vine Ripe',NULL,'0000000004805',NULL,'4805');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (577,'Turnip Bunch',NULL,'0000000004810',NULL,'4810');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (578,'Turnip',NULL,'0000000004811','https://www.kroger.com/product/images/large/front/0000000004811','4811');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (579,'Turnip',NULL,'0000000004812','https://www.kroger.com/product/images/large/front/0000000004812','4812');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (580,'Water Chestnuts',NULL,'0000000004814',NULL,'4814');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (581,'Watercress',NULL,'0000000004815','https://www.kroger.com/product/images/large/front/0000000004815','4815');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (582,'Potatoes - Sweet - Jewel Yams',NULL,'0000000004816','https://www.kroger.com/product/images/small/front/0000000004816','4816');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (583,'Yams - Garnet - Red',NULL,'0000000004817','https://www.kroger.com/product/images/large/front/0000000004817','4817');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (584,'Yucca Root',NULL,'0000000004819','https://www.kroger.com/product/images/large/front/0000000004819','4819');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (585,'Snrg Dates Ptd',NULL,'0000000004862',NULL,'4862');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (586,'Onions - Cipolline',NULL,'0000000004867',NULL,'4867');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (587,'Basil',NULL,'0000000004885','https://www.kroger.com/product/images/large/front/0000000004885','4885');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (588,'Cilantro',NULL,'0000000004889','https://www.kroger.com/product/images/large/front/0000000004889','4889');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (589,'Pear - Yali',NULL,'0000000004890','https://www.kroger.com/product/images/large/front/0000000004890','4890');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (590,'Dry Dill Herbs',NULL,'0000000004891','https://www.kroger.com/product/images/large/front/0000000004891','4891');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (591,'Dill Baby',NULL,'0000000004892','https://www.kroger.com/product/images/large/front/0000000004892','4892');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (592,'Lemon Grass',NULL,'0000000004894','https://www.kroger.com/product/images/large/front/0000000004894','4894');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (593,'Mint',NULL,'0000000004896','https://www.kroger.com/product/images/large/front/0000000004896','4896');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (594,'Oyster Plant',NULL,'0000000004898',NULL,'4898');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (595,'Parsley',NULL,'0000000004899','https://www.kroger.com/product/images/large/front/0000000004899','4899');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (596,'Parsley - Italian',NULL,'0000000004901','https://www.kroger.com/product/images/large/front/0000000004901','4901');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (597,'Rosemary',NULL,'0000000004903','https://www.kroger.com/product/images/large/front/0000000004903','4903');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (598,'Sage',NULL,'0000000004904','https://www.kroger.com/product/images/large/front/0000000004904','4904');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (599,'Tarragon',NULL,'0000000004906','https://www.kroger.com/product/images/large/front/0000000004906','4906');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (600,'Thyme',NULL,'0000000004907','https://www.kroger.com/product/images/large/front/0000000004907','4907');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (601,'Sun-Maid Almonds Bulk',NULL,'0000000004924',NULL,'4924');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (602,'Brazilian Nuts In-Shell',NULL,'0000000004926',NULL,'4926');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (603,'Chestnuts - In-Shell - Italian - Bulk',NULL,'0000000004927','https://www.kroger.com/product/images/large/front/0000000004927','4927');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (604,'Hazelnuts - In Shell - Filbert',NULL,'0000000004928',NULL,'4928');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (605,'Sun-Maid Nuts Mix In-Shell Bulk',NULL,'0000000004929',NULL,'4929');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (606,'Hamp Peanuts Inshell Raw',NULL,'0000000004931',NULL,'4931');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (607,'Peanuts In Shell Roasted No Salt',NULL,'0000000004933',NULL,'4933');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (608,'Pecans - In-Shell - Bulk',NULL,'0000000004936','https://www.kroger.com/product/images/large/front/0000000004936','4936');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (609,'Walnuts - In-Shell - Bulk',NULL,'0000000004943','https://www.kroger.com/product/images/large/front/0000000004943','4943');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (610,'Lemons',NULL,'0000000004958','https://www.kroger.com/product/images/large/front/0000000004958','4958');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (611,'Mango - Red',NULL,'0000000004959','https://www.kroger.com/product/images/small/front/0000000004959','4959');
INSERT INTO `ingredient`(`id`,`name`,`description`,`upc`,`img_url`,`plu`) VALUES (612,'Mangoes - Honey - Ataulfo',NULL,'0000000004961','https://www.kroger.com/product/images/large/front/0000000004961','4961');
COMMIT;



-- -----------------------------------------------------
-- Data for table `company`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `company` (`id`, `name`, `api_host_url`) VALUES (1, 'King Soopers', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `store`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `store` (`id`, `street1`, `street2`, `city`, `state`, `zipcode`, `company_id`, `location_id`, `name`, `phone`) VALUES (1, '17171 S. Golden Rd.', NULL, 'Golden', 'CO', '80401', 1, NULL, NULL, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `recipe`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (1, 'Duck Raviolis', 'A Recipe for Raviolis that have farm raised duck', 'https://www.aberdeenskitchen.com/wp-content/uploads/2020/10/Homemade-Herbed-Three-Cheese-Ravioli-9.jpg', '2022-11-23T00:00:00', 'm Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard du', 30, 60, 1, 2);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (2, 'Baked Macaroni', 'Noodles, Cheese, more cheese', 'https://hips.hearstapps.com/clv.h-cdn.co/assets/16/08/1456262739-cl-speckled-malted-coconut-cake.jpg?crop=0.950xw:0.634xh;0.0192xw,0.331xh&resize=640:*', '2022-11-28 00:00:00', 'Cook Macaroni, add cheese, bake', 25, 35, 1, 3);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (3, 'Banana Cake', 'Bananas and cake', 'https://imagesvc.meredithcorp.io/v3/mm/image?q=60&c=sc&poi=face&url=https%3A%2F%2Fimg1.cookinglight.timeinc.net%2Fsites%2Fdefault%2Ffiles%2Fstyles%2F4_3_horizontal_-_1200x900%2Fpublic%2F1542062283%2Fchocolate-and-cream-layer-cake-1812-cover.jpg%3Fitok%3DR_xDiShk', '2022-11-29 00:00:00', 'Bake in three layer pans at 350 degrees.', 20, 30, 1, 4);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (4, 'Blueberry Coffee Cake', 'Blueberry, coffee and cake', 'https://chelsweets.com/wp-content/uploads/2019/04/IMG_1029-2-735x1103.jpg', '2022-11-30 00:00:00', 'Mix butter, 1 cup sugar, flour, 2 eggs, 2 tsp vanilla, baking powder, and milk to make cake batter. Blend easily. Add 3 cups of blueberries. Put 2 1/2 cups of batter in pan. Mix cream cheese, 1/2 cup sugar, 1 egg, lemon juice and 1 tsp vanilla to make filling. Put filling on top of batter. Top with remaining batter. Make streusel topping from flour, butter, brown sugar, ad cinnamon. Sprinkle on top of cake. Bake at 375 degrees for 1 hour and 5 minutes. Check after 50 minutes.', 35, 40, 1, 2);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (5, 'Chocolate Cake', 'Chocolate and cake', 'https://www.blessthismessplease.com/wp-content/uploads/2021/04/candy-cake-5.jpg', '2022-12-1 00:00:00', 'Mix all ingredients together. Pour in 1 cup boiling water. Mix well. Bake about 35 minutes at 375 degrees.\n', 45, 45, 1, 3);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (6, 'Crazy Cake', 'Crazy and cake', 'https://www.bhg.com/thmb/ziGTCoVTmBnzZ--M5oXHE-UTnFM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/fresh-pear-pistachio-cake-RU195582-3e27c285c5ea45c39f8154e517899176.jpg', '2022-12-2 00:00:00', 'Mix first 5 ingredients well, about 4 minutes. Bake at 350 degrees in a 9x13 pan for 35 minutes. Poke holes in warm cake and pour on mixture of powdered sugar and lemon juice.', 23, 50, 1, 5);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (7, 'Fresh Apple Cake', 'Yup, apples and cake', 'https://preppykitchen.com/wp-content/uploads/2018/04/Funfetti-cake-recipe-new.jpg', '2022-12-3 00:00:00', 'Mix apples and sugar well. Add oil, nuts, and eggs. Add vanilla and dry ingredients. Bake at 350 degrees for 40-45 minutes. Serve with whipped cream or top with cream cheese frosting.', 20, 60, 1, 6);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (8, 'Fresh Pear Cake', 'Pears and Cake', 'https://media-cldnry.s-nbcnews.com/image/upload/newscms/2022_18/1868101/snacking-cake-coleman-kb-2x1-220502.jpg', '2022-12-4 00:00:00', 'Butter and flour a 9 inch round pan. Peel and slice pears. Blend eggs, sugar, milk, and salt. Add flour, mix well. Fold 1/2 of pears into batter. Pour into pan, fan remaining pears on top. Dot with butter. Bake at 350 degrees about 55 minutes. Sprinkle with powdered sugar.', 15, 45, 1, 7);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (9, 'Graham Cracker Cake', 'Crackers and Cake', 'https://www.washingtonpost.com/resizer/FoXc-qH9P8gNC0C0KDYKToPoYAE=/arc-anglerfish-washpost-prod-washpost/public/T3C634ROYUI63PGGBB2LE2XCSY.jpg', '2022-12-5 00:00:00', 'Cream butter and sugar. Add crushed crackers, sour milk, and soda. Stir in nuts. Bake in 10 inch square baking pan. Bake in 350 degree oven for 30-35 minutes. Serve with whipped cream or thin powdered sugar icing.', 25, 40, 1, 8);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (10, 'Hot Water Chocolate Cake', 'Water and Cake', 'https://images.immediate.co.uk/production/volatile/sites/30/2020/08/digger-cake_0-c4711f0.jpg', '2022-12-6 00:00:00', 'Mix all ingredients together. Pour in 1 cup boiling water. Mix well. Bake about 35 minutes at 375 degrees.\n', 30, 35, 1, 9);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (11, 'Hungry Bear Cheese Cake', 'Bears and Cake', 'https://lilluna.com/wp-content/uploads/2022/09/poke-cake3-resize-1-500x500.jpg', '2022-12-7 00:00:00', 'Combine first 5 ingredients to make crust. Save 1/4 cup for top. Press remaining crumbs evenly over bottom and about 2 inches up sides of a 9 inch spring form pan. Prepare filling: beat cream cheese and cottage cheese until smooth. Add eggs, one at a time, bating well. Blend in lemon juice and vanilla. Mix sugar, flour and salt. Add to cheese mixture. Pour into crust. Bake at 350 degrees until set, about 35 to 40 minutes. Combine topping ingredients (sour cream, sugar, vanilla, and salt). Spread evenly over hot cheese cake. Return to oven until cream sets, about 5 minutes. Cool in pan on rack. Sprinkle reserved crumbs around edge of cake.\n', 35, 25, 1, 12);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (12, 'Lemon Poppy Cake', 'Lemons, poppies and cake', 'https://alittlecake.com/wp-content/uploads/2022/04/Cherry-Blossom-Fondant-Iced-Wedding-Cake-550x675.jpg', '2022-12-8 00:00:00', 'Mix all for 4 minutes. Bake at 350 degrees for 40 minutes.\n', 20, 35, 1, 11);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (13, 'Light Old Fashioned Cake', 'Cake', 'https://preppykitchen.com/wp-content/uploads/2021/11/Chiffon-Cake-Recipe-Card-500x500.jpg', '2022-12-9 00:00:00', 'Sift dry ingredients into a 4 quart bowl. Add fruit and nuts. Mix until well coated. Set aside. Cream butter, gradually add sugar and cream until fluffy. Add eggs one at a time, beating well after each. Add brandy. Combine with fruit mixture. Mix well. Turn into a 10 inch tube pan or four 1# coffee cans lined with foil, filling pans 2/3 full. Bake in slow oven, 275 degrees for 2 3/4 to 3 hours. About 1/2 hour before done brush lightly with honey or light corn syrup. Cool completely then wrap tightly in foil to store for several weeks. Brush with brandy about once a week.\n', 15, 45, 1, 12);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (14, 'My Best Gingerbread', 'Gingerbread cake', 'https://upload.wikimedia.org/wikipedia/commons/5/59/Christmas_cake_%286954064737%29.jpg', '2022-12-10 00:00:00', 'Bake in greased pan for 35 minutes at 325-350 degrees.\n', 20, 45, 1, 13);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (15, 'Oatmeal Cake', 'Oatmeal and cake', 'https://www.lovefromtheoven.com/wp-content/uploads/2015/08/dog-cake-recipe-500x375.jpg', '2022-12-11 00:00:00', 'Pour the water over the oatmeal. Let stand for 20 minutes. Add remaining cake ingredients. Mix well and pour into a greased 9\"x12\" pan. Let stand while mixing topping. To prepare topping: Mix all ingredients together over low heat, until butter melts. Spoon over unbaked cake. Bake 45 minutes at 350 degrees.\n', 30, 45, 1, 13);
INSERT INTO `recipe`(`id`,`name`,`description`,`img_url`,`creation_date`,`instructions`,`prep_time`,`cook_time`,`user_id`) VALUES (16,'Chili','$20,000 award winning chili','https://www.google.com/imgres?imgurl=https%3A%2F%2Fwww.thewholesomedish.com%2Fwp-content%2Fuploads%2F2018%2F05%2FThe-Best-Classic-Chili-550-500x375.jpg&imgrefurl=https%3A%2F%2Fwww.thewholesomedish.com%2Fthe-best-classic-chili%2F&tbnid=AK21RBhQLOCAWM&vet=12ahUKEwji-KfWv-H7AhU7FlkFHUCUBqoQMygAegUIARCHAg..i&docid=LKWanpI5xfDg8M&w=500&h=375&itg=1&q=chili&ved=2ahUKEwji-KfWv-H7AhU7FlkFHUCUBqoQMygAegUIARCHAg','2022-12-1 00:00:00','In large saucepan or Dutch oven, brown half the meat; pour off fat. Remove meat. Brown remaining meat; pour off all fat except 2 Tbsps. Add onion, garlic; cook and stir until tender. Add meat and remaining ingredients except flour, cornmeal and warm water. Mix well. Bring to boil; reduce heat and simmer covered 2 hours. Stir together flour and cornmeal; add warm water. Mix well. Stir into chili mixture. Cook covered 20 minutes longer. Serve hot. Makes 2 quarts.',60,270,4);
INSERT INTO `recipe`(`id`,`name`,`description`,`img_url`,`creation_date`,`instructions`,`prep_time`,`cook_time`,`user_id`) VALUES (17,'Naan Bread','Chewy, bubbly naan bread','https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.budgetbytes.com%2Fnaan%2F&psig=AOvVaw0oKPY5torQnmK2CG_i5fao&ust=1670296181994000&source=images&cd=vfe&ved=0CA8QjRxqFwoTCKDKuqfA4fsCFQAAAAAdAAAAABAD','2022-12-1 00:00:00','In a small bowl, add the sugar, warm water, and yeast together. Stir to combine well. The yeast should be activated when it becomes foamy, about 10 minutes. Transfer the flour to a flat surface and make a well in the middle. Add the yeast mixture, yoghurt, salt and oil, knead the dough until the surface becomes smooth and shiny, about 10 minutes. Cover the dough with a damp cloth and let it rise in a warm place (for example: beside the stovetop or warm oven). The dough should double in size, about 1 hour.
    Divide the dough into 8 equal portions. Roll the dough to a 8” circle using a rolling spin.
    Heat up a skillet (cast-iron preferred) over high heat and lightly grease the surface with some oil to avoid the dough from sticking to the skillet. Place the dough on the skillet. When it puffs up and bubbles and burnt spots appear, flip it over and cook the other side. Repeat the same until all dough are done.
    Brush the naan with the melted butter, serve warm.',120,15,12);
INSERT INTO `recipe`(`id`,`name`,`description`,`img_url`,`creation_date`,`instructions`,`prep_time`,`cook_time`,`user_id`) VALUES (18,'Duck Foie Gras','Duck and fat','https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.umami.site%2Frecipes%2Fseared-foie-gras-with-caramelized-figs%2F&psig=AOvVaw2AJH742HaVs5zAHshiToAm&ust=1670296474429000&source=images&cd=vfe&ved=0CA8QjRxqFwoTCMjb77TB4fsCFQAAAAAdAAAAABAI','2022-12-1 00:00:00','After deveining, cut the foie gras crosswise into 1/2-inch-thick pieces, then season with salt and pepper.Heat 1 teaspoon of the canola oil in a 10-inch heavy skillet over moderately high heat until hot but not smoking.Sauté half the foie gras until golden, 45 to 60 seconds on each side (it will be pink inside). Quickly transfer to a paper towel to drain and discard fat in skillet.Sauté the rest of the foie gras the same way, then discard all all but 1 tablespoon of remaining fat in skillet. Add 2 tablespoons balsamic vinegar and bring to a boil. Serve foie gras with sauce.',60,270,17);
INSERT INTO `recipe`(`id`,`name`,`description`,`img_url`,`creation_date`,`instructions`,`prep_time`,`cook_time`,`user_id`) VALUES (19,'Baked Alaska','Alaska but baked','https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fimages.media-allrecipes.com%2Fuserphotos%2F8797692.jpg&q=60&c=sc&orient=true&poi=auto&h=512','2022-12-1 00:00:00','Line the bottom and sides of an 8-inch round mixing bowl with plastic wrap. Pack softened ice cream into the prepared bowl, then flatten the top and cover with more plastic wrap. Freeze until firm, 8 hours to overnight.    Beat egg whites, sugar, cream of tartar, and salt in a mixing bowl until stiff peaks form.',25,15,2);
INSERT INTO `recipe`(`id`,`name`,`description`,`img_url`,`creation_date`,`instructions`,`prep_time`,`cook_time`,`user_id`) VALUES (20,'Cajun Turkey Pot Pie','A turkey pot pie made with turkey leftovers and flavored with Cajun spices, onions, celery and green pepper.','https://www.simplyrecipes.com/thmb/lihILdBInEahSWBHSgquxxCqIB0=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/Simply-Recipes-Cajun-Turkey-Pot-Pie-LEAD-2-f4b2045b3057415c9679676b2f9f3e37.jpg','2022-12-1 00:00:00','Make the pie crust dough:
Pulse the flour and salt together in a food processor. Add the chilled butter cubes to the food processor and pulse 5 times. The dough should resemble a coarse cornmeal, with some pea-sized pieces of butter.
Slowly add the chilled water (make sure there are no small ice cube bits), just a tablespoon at a time, pulsing once after each addition, until the dough just sticks together when you press some between your fingers.
Empty the food processor, placing the dough mixture on a clean surface. Use the heel of your palm to shmoosh the dough mixture onto the table surface a few times. This action will help flatten and spread the butter between layers of flour, so that the resulting dough will be flaky.
Once you''ve done this a few (5 or 6) times, use your hands to mold the dough into a disk. Sprinkle the disk with a little flour, wrap it in plastic wrap, and let it chill for an hour, or up to 2 days, before rolling out.',60,90,30);
INSERT INTO `recipe`(`id`,`name`,`description`,`img_url`,`creation_date`,`instructions`,`prep_time`,`cook_time`,`user_id`) VALUES (21,'Creamy Cheesy Turkey Enchiladas','Creamy cheesy turkey enchiladas! Leftover turkey, sweet potatoes, and cream cheese rolled into flour tortillas, smothered with creamy salsa verde sauce. So good!','https://www.simplyrecipes.com/thmb/bNTTCwp8uzGZwCY7-18-4HylWoA=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/__opt__aboutcom__coeus__resources__content_migration__simply_recipes__uploads__2014__11__creamy-turkey-enchiladas-vertical-a-1800-44a2e00a9153478f9495f31fa5726a0d.jpg','2022-12-1 00:00:00','Melt butter in small saucepan on medium-high heat. Add the finely diced onion and sauté until golden and lightly browned. Stir the ground cumin into the onions and cook for a minute more. Remove from heat and let cool',45,45,12);
INSERT INTO `recipe`(`id`,`name`,`description`,`img_url`,`creation_date`,`instructions`,`prep_time`,`cook_time`,`user_id`) VALUES (22,'White Bean and Ham Soup','Hearty Ham and Bean Soup, perfect for cold winter days! White beans, ham shanks, onions, celery, carrots, garlic, Tabasco, and herbs make this delicious ham and bean soup a cool weather classic.','https://www.simplyrecipes.com/thmb/nFUHREBYPxO-cgOQSIqwPQ24oRs=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/Ham-and-Bean-Soup-LEAD-1-1463x2048-1383941be5774263a0212b7382987ae4.jpg','2022-12-1 00:00:00','While the beans are soaking in step 1, put the ham shanks or ham hocks in a separate large pot and cover them with 2 quarts of water. Add the herbes de Provence or Italian seasoning. Warm on high heat until the water comes to a simmer, then lower the heat, partially cover and maintain the simmer for about an hour.',45,270,19);
INSERT INTO `recipe`(`id`,`name`,`description`,`img_url`,`creation_date`,`instructions`,`prep_time`,`cook_time`,`user_id`) VALUES (23,'Turkey Tacos with Cranberry salsa','Turkey tacos recipe with cranberry salsa! Another great way to use up Thanksgiving turkey leftovers.','https://www.simplyrecipes.com/thmb/eyZOfBcddQjck1GKidNwIugDJuo=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/__opt__aboutcom__coeus__resources__content_migration__simply_recipes__uploads__2007__11__turkey-tacos-cranberry-salsa-vertical-a-1600-97c8337234b44bc496c306427cb1afaf.jpg','2022-12-1 00:00:00','Put the cranberries, apple, chile, sugar, ginger, cilantro, and lime or lemon juice in a food processor and pulse until coarsely shredded, about 10 short pulses.
Let sit 15 minutes for the cranberries to macerate. You can also use cranberry relish, just add chopped chiles and cilantro.',25,10,40);
INSERT INTO `recipe`(`id`,`name`,`description`,`img_url`,`creation_date`,`instructions`,`prep_time`,`cook_time`,`user_id`) VALUES (24,'Ultimate Club Sandwich','What makes this club sandwich the ULTIMATE? Oven roasted turkey, crispy bacon, fresh veggies, and a homemade garlic aioli! This club sandwich takes a little time to build, but it’s worth every step.','https://www.simplyrecipes.com/thmb/GrgYms8955pO_-LzExBN6PB5Pyc=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/__opt__aboutcom__coeus__resources__content_migration__simply_recipes__uploads__2020__04__Turkey-Club-LEAD-2-25b010bb758c4201af830bbe335ae049.jpg','2022-12-1 00:00:00','While the turkey breast roasts, cut the top off a garlic bulb, exposing the garlic cloves. Set the garlic bulb cut side up on a square of foil large enough to enclose it. Drizzle the head of garlic with a teaspoon of olive oil and a sprinkle of salt. Wrap in the foil.',15,5,38);
INSERT INTO `recipe`(`id`,`name`,`description`,`img_url`,`creation_date`,`instructions`,`prep_time`,`cook_time`,`user_id`) VALUES (25,'Bubble and Squeak','Bubble and squeak is a great way to use up leftover mashed potatoes and the vegetables in your crisper. It''s a fixture of Boxing Day in Britain, but welcome at the table anytime.','https://www.simplyrecipes.com/thmb/6lEMAZomkOE-fqEkQJjaIut3wMo=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/Simply-Recipes-Bubble-and-Squeak-LEAD-03-ede1f2a5908443bcb81d57e83f26af8c.jpg','2022-12-1 00:00:00','When the butter is melted, add the patties into the skillet. Cook for 2 to 4 minutes on one side, until the bottoms are golden brown. Carefully flip them and cook for 2 to 4 minutes, until they are browned. Transfer the skillet into the oven to keep them warm while you fry the eggs.',15,5,23);
INSERT INTO `recipe`(`id`,`name`,`description`,`img_url`,`creation_date`,`instructions`,`prep_time`,`cook_time`,`user_id`) VALUES (26,'Easy Whipped Ricotta Toast','When you whip ricotta, it magically becomes airier, creamier, and perfect for smearing on a sturdy slice of bread. A drizzle of lemony, thyme-y honey on top, and you’ll be spellbound!','https://www.simplyrecipes.com/thmb/icUZLm2a0kovhoZYpXWWgoKcdJY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/Simply-Recipes-Whipped-Ricotta-Toast-LEAD-16-e71174262b23404f9e8e0b8b918080c8.jpg','2022-12-1 00:00:00','Lay the bread out on a large baking sheet. Brush both sides lightly with olive oil. Season the tops with 1 teaspoon salt total and a few grinds of black pepper. Bake until the tops are golden and toasted, about 10 minutes. You do not need to flip them halfway through.',10,5,18);
INSERT INTO `recipe`(`id`,`name`,`description`,`img_url`,`creation_date`,`instructions`,`prep_time`,`cook_time`,`user_id`) VALUES (27,'Breakfast Pizza with Cheddar, Bacon and Eggs','Your weekend breakfast plans just got a whole lot more exciting with this Breakfast Pizza loaded with eggs, cheddar cheese, and crispy bacon.','https://www.simplyrecipes.com/thmb/2e89tj8qkRReW61k-1ohFKvEgNw=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/Simply-Recipes-Breakfast-Pizza-LEAD-7-462e4ffd7461406cb4ea98073c0d68a6.jpg','2022-12-1 00:00:00','Flour a work surface. Place the ball of pizza dough on top and flatten it with your hands into a circle, around 1-inch thick. Dimple it with your fingers to help spread it out and cover it with a dishtowel.',15,20,16);
INSERT INTO `recipe`(`id`,`name`,`description`,`img_url`,`creation_date`,`instructions`,`prep_time`,`cook_time`,`user_id`) VALUES (28,'Kai Jeow','Kai jeow is a classic Thai omelet with the perfect balance of salty-sweet-hot flavors. Serve it simply, with rice and raw vegetables, for a quick and satisfying meal.','https://www.simplyrecipes.com/thmb/CV224gFmZdfx3DJJrK5FwtqLzJg=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/Simply-Recipes-Thai-Omelette-LEAD-5-5b849cc6d653475f950a4c0f4dcae8fb.jpg','2022-12-1 00:00:00','Heat vegetable oil in a small (about 8-inch diameter) nonstick skillet over medium-high heat until the oil is hot. You will know when the oil is ready when it smokes lightly.',15,30,7);
INSERT INTO `recipe`(`id`,`name`,`description`,`img_url`,`creation_date`,`instructions`,`prep_time`,`cook_time`,`user_id`) VALUES (29,'Chicken Vesuvio','Love garlic? Try this Italian-American specialty from Chicago. Chicken Vesuvio is a one-pan recipe of crispy chicken thighs, potato wedges, and peas in a lemony garlic-white wine sauce.','https://www.simplyrecipes.com/thmb/B5y-TyZCYqa8fNuCNeNEyx_cbv4=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/Simply-Recipes-Chicken-Vesuvio-LEAD-8-a7e8e80a04ba406a9c249ec7c4d268a0.jpg','2022-12-1 00:00:00','Heat a 12-inch cast-iron pan gradually over medium-low heat until it’s good and hot, about 10 minutes. (This may seem like a long time, but the pan is over medium-low during this time, and the payoff is nice and crispy golden-brown skin.)',10,60,8);
INSERT INTO `recipe`(`id`,`name`,`description`,`img_url`,`creation_date`,`instructions`,`prep_time`,`cook_time`,`user_id`) VALUES (30,'Tex-Mex Chopped Chicken Salad with Cilantro-Lime Dressing','Seasoned chicken, tortilla chips, and roasted corn pair perfectly together in this crunchy and craveable Tex-Mex chopped chicken salad with cilantro lime dressing.','https://www.simplyrecipes.com/thmb/e0J5nYHdvr3lHtZYUvsD53dcDYA=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/Simply-Recipes-Tex-Mex-Chopped-Chicken-LEAD-5-87fae3e1eaa543aeb2228daeab42f288.jpg','2022-12-1 00:00:00','In the same skillet used to cook the corn add 1 tablespoon of olive oil and set over medium-high heat. When the oil is hot, add the chicken and cook until deeply brown along the bottom and the flesh turns opaque about halfway up the side, 4 to 5 minutes.',15,30,4);

COMMIT;


-- -----------------------------------------------------
-- Data for table `user_favorite_store`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `user_favorite_store` (`user_id`, `store_id`) VALUES (2, 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `favorite_recipe`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `favorite_recipe` (`recipe_id`, `user_id`) VALUES (1, 2);

COMMIT;


-- -----------------------------------------------------
-- Data for table `recipe_ingredient`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `recipe_ingredient` (`recipe_id`, `ingredient_id`, `measurement`) VALUES (1, 1, '1/2 cup');
INSERT INTO `recipe_ingredient` (`recipe_id`, `ingredient_id`, `measurement`) VALUES (1, 2, '1 cup');
INSERT INTO `recipe_ingredient` (`recipe_id`, `ingredient_id`, `measurement`) VALUES (1, 3, '1 tbsp');
INSERT INTO `recipe_ingredient` (`recipe_id`, `ingredient_id`, `measurement`) VALUES (1, 4, '1 lb');
INSERT INTO `recipe_ingredient` (`recipe_id`, `ingredient_id`, `measurement`) VALUES (1, 5, '1 tbsp');
INSERT INTO `recipe_ingredient` (`recipe_id`, `ingredient_id`, `measurement`) VALUES (1, 6, '1/2 cup');
INSERT INTO `recipe_ingredient` (`recipe_id`, `ingredient_id`, `measurement`) VALUES (1, 7, '1 whole');
INSERT INTO `recipe_ingredient` (`recipe_id`, `ingredient_id`, `measurement`) VALUES (1, 8, '1 clove');

COMMIT;


-- -----------------------------------------------------
-- Data for table `reaction`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `reaction` (`id`, `emoji`) VALUES (1, '128516');

COMMIT;


-- -----------------------------------------------------
-- Data for table `recipe_reaction`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `recipe_reaction` (`recipe_id`, `user_id`, `reaction_id`, `reaction_date`) VALUES (1, 2, 1, '2022-11-23T00:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `recipe_comment`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `recipe_comment` (`id`, `comment_date`, `comment`, `user_id`, `recipe_id`, `in_reply_to`) VALUES (1, '2022-11-23T00:00:00', 'I made this for Thanksgiving and it was off the wall!', 2, 1, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `category`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `category` (`id`, `name`) VALUES (1, 'Produce');
INSERT INTO `category` (`id`, `name`) VALUES (2, 'Bakery');
INSERT INTO `category` (`id`, `name`) VALUES (3, 'Baking Goods');
INSERT INTO `category` (`id`, `name`) VALUES (4, 'Beverages');
INSERT INTO `category` (`id`, `name`) VALUES (5, 'International');
INSERT INTO `category` (`id`, `name`) VALUES (6, 'Deli');
INSERT INTO `category` (`id`, `name`) VALUES (7, 'Snacks');
INSERT INTO `category` (`id`, `name`) VALUES (8, 'Natural & Organic');
INSERT INTO `category` (`id`, `name`) VALUES (9, 'Example');

COMMIT;


-- -----------------------------------------------------
-- Data for table `ingredient_has_category`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (1, 9);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (2, 9);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (3, 9);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (4, 9);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (5, 9);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (6, 9);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (7, 9);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (8, 9);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (9, 9);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (10, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (11, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (12, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (13, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (14, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (15, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (16, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (17, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (18, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (19, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (20, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (21, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (23, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (24, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (25, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (26, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (27, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (28, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (29, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (30, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (31, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (32, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (33, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (34, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (35, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (36, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (37, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (38, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (39, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (40, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (41, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (42, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (43, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (44, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (45, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (46, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (47, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (48, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (49, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (50, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (51, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (52, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (53, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (54, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (55, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (56, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (57, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (58, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (59, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (60, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (61, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (62, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (63, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (64, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (65, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (66, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (67, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (68, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (69, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (70, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (71, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (72, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (73, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (74, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (75, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (76, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (77, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (78, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (79, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (80, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (81, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (82, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (83, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (84, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (85, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (86, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (87, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (88, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (89, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (90, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (91, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (92, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (93, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (94, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (96, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (97, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (98, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (99, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (100, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (101, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (102, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (103, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (104, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (105, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (106, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (107, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (108, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (109, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (110, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (111, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (112, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (113, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (114, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (115, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (117, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (118, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (119, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (120, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (121, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (122, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (123, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (124, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (125, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (126, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (127, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (128, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (129, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (130, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (131, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (132, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (133, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (134, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (135, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (136, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (137, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (138, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (139, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (140, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (141, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (142, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (143, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (144, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (145, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (146, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (147, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (148, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (149, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (150, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (151, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (152, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (153, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (154, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (155, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (156, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (157, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (158, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (159, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (160, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (161, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (162, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (163, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (164, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (165, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (166, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (167, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (168, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (169, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (170, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (171, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (172, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (173, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (174, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (175, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (176, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (177, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (178, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (179, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (180, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (181, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (182, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (183, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (184, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (185, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (186, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (187, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (188, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (189, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (190, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (191, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (192, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (193, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (194, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (195, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (196, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (197, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (198, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (199, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (200, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (201, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (202, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (203, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (204, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (205, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (206, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (207, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (208, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (209, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (210, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (211, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (212, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (213, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (214, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (215, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (216, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (217, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (218, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (219, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (220, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (221, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (222, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (223, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (224, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (225, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (226, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (227, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (228, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (229, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (230, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (231, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (232, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (233, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (234, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (235, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (236, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (237, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (238, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (239, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (240, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (241, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (242, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (243, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (244, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (245, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (246, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (247, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (248, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (249, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (250, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (251, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (252, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (253, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (254, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (255, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (256, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (257, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (258, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (259, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (260, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (261, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (262, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (263, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (264, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (265, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (266, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (267, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (268, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (269, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (270, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (271, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (272, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (273, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (274, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (275, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (276, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (277, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (278, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (279, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (280, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (281, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (282, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (283, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (284, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (285, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (286, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (287, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (288, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (289, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (290, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (291, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (292, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (293, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (294, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (295, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (296, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (297, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (298, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (299, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (300, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (301, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (302, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (303, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (304, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (305, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (306, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (307, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (308, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (309, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (310, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (311, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (312, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (313, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (314, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (315, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (316, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (317, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (318, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (319, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (320, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (321, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (322, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (323, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (324, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (325, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (326, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (327, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (328, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (329, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (330, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (331, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (332, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (333, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (334, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (335, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (336, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (337, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (338, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (339, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (340, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (341, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (342, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (343, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (344, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (345, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (346, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (347, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (348, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (349, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (351, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (352, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (353, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (354, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (355, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (356, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (357, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (358, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (359, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (360, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (361, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (362, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (363, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (364, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (365, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (366, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (367, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (368, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (369, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (370, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (371, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (372, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (373, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (374, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (375, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (376, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (377, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (378, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (379, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (380, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (381, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (382, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (383, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (384, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (385, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (386, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (388, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (389, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (390, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (391, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (392, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (393, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (394, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (395, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (396, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (397, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (398, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (399, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (400, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (401, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (402, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (403, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (404, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (405, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (406, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (407, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (408, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (409, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (410, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (411, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (412, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (413, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (414, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (415, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (416, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (417, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (418, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (419, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (420, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (421, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (422, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (423, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (424, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (425, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (426, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (427, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (428, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (429, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (430, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (431, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (432, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (433, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (434, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (435, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (436, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (437, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (438, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (439, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (440, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (441, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (442, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (443, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (444, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (445, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (446, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (447, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (448, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (449, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (450, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (451, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (452, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (453, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (454, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (455, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (456, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (457, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (458, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (459, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (460, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (461, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (462, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (463, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (464, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (465, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (466, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (467, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (468, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (469, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (470, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (471, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (472, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (473, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (474, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (475, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (476, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (477, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (478, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (479, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (480, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (481, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (482, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (483, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (484, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (485, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (486, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (487, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (488, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (489, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (490, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (491, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (492, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (493, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (494, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (495, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (496, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (497, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (498, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (499, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (500, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (501, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (502, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (503, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (504, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (505, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (506, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (507, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (508, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (509, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (510, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (511, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (512, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (513, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (514, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (515, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (516, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (517, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (519, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (520, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (521, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (522, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (523, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (524, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (525, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (526, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (527, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (528, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (529, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (530, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (531, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (532, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (533, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (534, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (535, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (536, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (537, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (538, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (539, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (540, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (541, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (542, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (543, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (544, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (545, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (546, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (547, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (548, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (549, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (550, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (551, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (552, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (553, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (554, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (555, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (556, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (557, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (558, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (559, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (560, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (561, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (562, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (563, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (564, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (565, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (566, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (567, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (568, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (569, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (570, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (571, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (572, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (573, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (574, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (575, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (576, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (577, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (578, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (579, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (580, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (581, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (582, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (583, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (584, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (586, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (588, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (589, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (590, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (592, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (594, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (595, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (596, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (597, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (598, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (603, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (608, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (609, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (610, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (611, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (612, 1);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (22, 2);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (95, 3);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (587, 3);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (591, 3);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (116, 4);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (350, 5);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (518, 5);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (387, 6);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (585, 7);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (601, 7);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (602, 7);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (604, 7);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (605, 7);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (606, 7);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (607, 7);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (593, 8);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (599, 8);
INSERT INTO `ingredient_has_category` (`ingredient_id`, `category_id`) VALUES (600, 8);

COMMIT;
