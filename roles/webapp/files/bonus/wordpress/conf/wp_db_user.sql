INSERT IGNORE INTO $WP_DB_NAME.wp_users (ID, user_login, user_pass, user_nicename, user_email, user_url, user_registered, user_activation_key, user_status, display_name) VALUES ('2', '$WP_DB_USER', MD5('$WP_DB_PASSWORD'), '$WP_DB_USER', '$WP_DB_USER@42.fr', 'http://www.42.fr/', '2022-09-08 00:00:00', '', '0', '$WP_DB_USER');
INSERT IGNORE INTO $WP_DB_NAME.wp_usermeta (umeta_id, user_id, meta_key, meta_value) VALUES (NULL, '2', 'wp_capabilities', 'a:1:{s:6:"author";b:1;}');
INSERT IGNORE INTO $WP_DB_NAME.wp_usermeta (umeta_id, user_id, meta_key, meta_value) VALUES (NULL, '2', 'wp_user_level', '2');
INSERT IGNORE INTO $WP_DB_NAME.wp_usermeta (umeta_id, user_id, meta_key, meta_value) VALUES (NULL, '2', 'nickname', '$WP_DB_NAME');
INSERT IGNORE INTO $WP_DB_NAME.wp_usermeta (umeta_id, user_id, meta_key, meta_value) VALUES (NULL, '2', 'rich_editing', true);
INSERT IGNORE INTO $WP_DB_NAME.wp_usermeta (umeta_id, user_id, meta_key, meta_value) VALUES (NULL, '2', 'syntax_highlighting', true);