<?php
return [
    'backend' => [
        'frontName' => 'admin'
    ],
    'remote_storage' => [
        'driver' => 'file'
    ],
    'queue' => [
        'amqp' => [
            'host' => 'rabbitmq',
            'port' => '5672',
            'user' => 'admin',
            'password' => 'admin',
            'virtualhost' => '/'
        ],
        'consumers_wait_for_messages' => 0
    ],
    'crypt' => [
        'key' => '272b2d716b69075e0a5871ee9021ffa7'
    ],
    'db' => [
        'table_prefix' => '',
        'connection' => [
            'default' => [
                'host' => 'database',
                'dbname' => 'magento',
                'username' => 'magento',
                'password' => 'magento',
                'model' => 'mysql4',
                'engine' => 'innodb',
                'initStatements' => 'SET NAMES utf8;',
                'active' => '1',
                'driver_options' => [
                    1014 => false
                ]
            ]
        ]
    ],
    'resource' => [
        'default_setup' => [
            'connection' => 'default'
        ]
    ],
    'x-frame-options' => 'SAMEORIGIN',
    'MAGE_MODE' => 'default',
    'http_cache_hosts' => [
        [
            'host' => 'varnish'
        ]
    ],
    'session' => [
        'save' => 'redis',
        'redis' => [
            'host' => 'session',
            'port' => '6379',
            'password' => '',
            'timeout' => '5',
            'persistent_identifier' => '',
            'database' => '0',
            'compression_threshold' => '2048',
            'compression_library' => 'gzip',
            'log_level' => '1',
            'max_concurrency' => '10',
            'break_after_frontend' => '5',
            'break_after_adminhtml' => '30',
            'first_lifetime' => '600',
            'bot_first_lifetime' => '60',
            'bot_lifetime' => '7200',
            'disable_locking' => 'true',
            'min_lifetime' => '60',
            'max_lifetime' => '2592000',
            'sentinel_master' => '',
            'sentinel_servers' => '',
            'sentinel_connect_retries' => '5',
            'sentinel_verify_master' => '0'
        ]
    ],
    'cache' => [
        'frontend' => [
            'default' => [
                'id_prefix' => '69d_',
                'backend' => 'Magento\\Framework\\Cache\\Backend\\Redis',
                'backend_options' => [
                    'server' => 'cache',
                    'database' => '0',
                    'port' => '6379',
                    'password' => '',
                    'compress_data' => '1',
                    'compression_lib' => ''
                ]
            ],
            'page_cache' => [
                'id_prefix' => '69d_'
            ]
        ],
        'allow_parallel_generation' => true
    ],
    'lock' => [
        'provider' => 'db',
        'config' => [
            'prefix' => null
        ]
    ],
    'directories' => [
        'document_root_is_pub' => true
    ],
    'cache_types' => [
        'config' => 1,
        'layout' => 1,
        'block_html' => 1,
        'collections' => 1,
        'reflection' => 1,
        'db_ddl' => 1,
        'compiled_config' => 1,
        'eav' => 1,
        'customer_notification' => 1,
        'config_integration' => 1,
        'config_integration_api' => 1,
        'full_page' => 1,
        'config_webservice' => 1,
        'translate' => 1
    ],
    'downloadable_domains' => [
        'demo.local'
    ],
    'install' => [
        'date' => 'Fri, 22 Jul 2022 06:25:21 +0000'
    ],
    'cron_consumers_runner' => [
        'cron_run' => false,
        'max_messages' => 10,
        'consumers' => [

        ]
    ],
    'system' => [
        'default' => [
            'twofactorauth' => [
                'general' => [
                    'enable' => '0'
                ]
            ],
            'admin' => [
                'security' => [
                    'password_is_forced' => '0',
                    'password_reset_protection_type' => '0',
                    'admin_account_sharing' => '1',
                    'session_lifetime' => '31536000',
                    'lockout_failures' => '1000',
                    'password_lifetime' => '365'
                ],
                'captcha' => [
                    'enable' => '0'
                ],
                'usage' => [
                    'enabled' => '0'
                ]
            ],
            'dev' => [
                'template' => [
                    'allow_symlink' => '1'
                ]
            ],
            'system' => [
                'security' => [
                    'max_session_size_admin' => '0',
                    'max_session_size_storefront' => '0'
                ]
            ]
        ]
    ]
];
