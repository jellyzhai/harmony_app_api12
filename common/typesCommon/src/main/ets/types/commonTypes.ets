export interface IOpenLinkParams {
  fromAbilityUri: string;
  fromPageUrl: string;
  targetPageUrl: string;
}

export interface IPayWantParams extends IOpenLinkParams {
  storeId: string;
  payAmount: number;
}