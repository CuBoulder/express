<?php

/*
 * This file is part of the Behat MinkExtension.
 * (c) Konstantin Kudryashov <ever.zet@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Behat\MinkExtension\ServiceContainer\Driver;

use Symfony\Component\Config\Definition\Builder\ArrayNodeDefinition;

class SauceLabsFactory extends Selenium2Factory
{
    /**
     * {@inheritdoc}
     */
    public function getDriverName()
    {
        return 'sauce_labs';
    }

    /**
     * {@inheritdoc}
     */
    public function configure(ArrayNodeDefinition $builder)
    {
        $builder
            ->children()
                ->scalarNode('username')->defaultValue(getenv('SAUCE_USERNAME'))->end()
                ->scalarNode('access_key')->defaultValue(getenv('SAUCE_ACCESS_KEY'))->end()
                ->booleanNode('connect')->defaultFalse()->end()
                ->scalarNode('browser')->defaultValue('chrome')->end()
               // ->scalarNode('seleniumVersion')->defaultValue('firefox')->end()
                ->scalarNode('maxDuration')->defaultValue(1200)->end()
                ->scalarNode('maxInstances')->defaultValue(100)->end()
                ->scalarNode('commandTimeout')->defaultValue(600)->end()
                ->scalarNode('platform')->defaultValue('Windows 10')->end()
                ->scalarNode('version')->defaultValue('14.14393')->end()
                ->append($this->getCapabilitiesNode())
            ->end()
        ;
    }

    /**
     * {@inheritdoc}
     */
    public function buildDriver(array $config)
    {
        $host = 'ondemand.saucelabs.com';
        if ($config['connect']) {
            $host = 'localhost:4445';
        }

        $config['wd_host'] = sprintf('%s:%s@%s/wd/hub', $config['username'], $config['access_key'], $host);

        return parent::buildDriver($config);
    }

    protected function getCapabilitiesNode()
    {
        $node = parent::getCapabilitiesNode();

        $node
            ->children()
                // ->scalarNode('platform')->defaultValue('Linux')->end()
                ->scalarNode('idle-timeout')->end()
                ->scalarNode('build')->info('will be set automatically based on the TRAVIS_BUILD_NUMBER environment variable if available')->end()
                ->scalarNode('screen-resolution')->end()
                ->scalarNode('tunnel-identifier')->info('will be set automatically based on the TRAVIS_JOB_NUMBER environment variable if available')->end()
                ->arrayNode('prerun')
                    ->children()
                        ->scalarNode('executable')->isRequired()->end()
                        ->arrayNode('args')->prototype('scalar')->end()->end()
                        ->booleanNode('background')->defaultFalse()->end()
                    ->end()
                ->end()
                ->booleanNode('record-video')->end()
                ->booleanNode('record-screenshots')->end()
                ->booleanNode('capture-html')->end()
                ->booleanNode('disable-popup-handler')->end()
            ->end()
            ->validate()
                ->ifTrue(function ($v) {return empty($v['custom-data']);})
                ->then(function ($v) {
                    unset ($v['custom-data']);

                    return $v;
                })
            ->end()
        ;

        return $node;
    }
}
