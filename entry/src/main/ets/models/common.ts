import { Want } from '@kit.AbilityKit';

export enum HiLogDomainTagEnum {
  domain = 0x1234,
  tag = 'test_tag'
}

export interface WantParametersForResult extends Record<string, Object> {
  info: string;
  callerWant: Want
}