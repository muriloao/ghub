import { Controller, Get, Param, NotFoundException } from '@nestjs/common';
import { GamingPlatformService } from '../services/gaming-platform.service';
import { GamingPlatformDto, PlatformsListResponseDto } from '../dto/gaming-platform.dto';

@Controller('platforms')
export class GamingPlatformController {
    constructor(private readonly gamingPlatformService: GamingPlatformService) { }

    @Get()
    getAllPlatforms(): PlatformsListResponseDto {
        return this.gamingPlatformService.getAllPlatforms();
    }

    @Get('enabled')
    getEnabledPlatforms(): PlatformsListResponseDto {
        return this.gamingPlatformService.getEnabledPlatforms();
    }

    @Get('available')
    getAvailablePlatforms(): PlatformsListResponseDto {
        return this.gamingPlatformService.getAvailablePlatforms();
    }

    @Get(':id')
    getPlatformById(@Param('id') id: string): GamingPlatformDto {
        const platform = this.gamingPlatformService.getPlatformById(id);
        if (!platform) {
            throw new NotFoundException(`Platform with id '${id}' not found`);
        }
        return platform;
    }
}