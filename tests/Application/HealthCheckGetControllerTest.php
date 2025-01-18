<?php

declare(strict_types=1);

namespace Tests\App\Application;

use Symfony\Bundle\FrameworkBundle\KernelBrowser;
use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

final class HealthCheckGetControllerTest extends WebTestCase
{
    private KernelBrowser $client;

    protected function setUp(): void
    {
        parent::setUp();
        $this->client = static::createClient();
        $this->client->setServerParameter('CONTENT_TYPE', 'application/json');
    }

    public function test_response_is_ok(): void
    {
        $this->client->request('GET', '/api/health-check');

        self::assertResponseIsSuccessful();
    }
}
