import { ArrowPathIcon } from '@heroicons/react/24/outline';
import clsx from 'clsx';
import Image from 'next/image';
import { lusitana } from '@/app/ui/fonts';
import { fetchLatestInvoices } from '@/app/lib/data';
import InvoiceStatus from '../invoices/status';

export default async function LatestInvoices() {
  const latestInvoices = await fetchLatestInvoices();

  if (!latestInvoices || latestInvoices.length === 0) {
    console.error("No invoices found.");
    return <div>No invoices to display.</div>;
  }

  return (
    <div className="flex w-full flex-col md:col-span-4">
      <h2 className={`${lusitana.className} mb-4 text-xl md:text-2xl`}>
        Latest Invoices
      </h2>
      <div className="flex grow flex-col justify-between rounded-xl bg-gray-50 p-4">
        <div className="bg-white px-6">
          {latestInvoices.map((invoice: any, i: number) => {
            return (
              <div
                key={invoice.id}
                className={clsx(
                  'flex flex-row items-center justify-between py-4',
                  {
                    'border-t': i !== 0,
                  }
                )}
              >
                <div className="flex items-center shrink-0">
                  <Image
                    src={invoice.image_url}
                    alt={`${invoice.name}'s profile picture`}
                    className="mr-4 rounded-full"
                    width={32}
                    height={32}
                  />
                  <div className="min-w-0">
                    <p className="truncate text-sm font-semibold md:text-base">
                      {invoice.name}
                    </p>
                    <p className="hidden text-sm text-gray-500 sm:block">
                      {invoice.email}
                    </p>
                  </div>
                </div>
                <div className="w-full text-right pr-6">
                  <InvoiceStatus status={invoice.status} />
                </div>
                <div className="min-w-0 text-right shrink-0">
                  <p className={`truncate text-sm font-medium md:text-base`}>
                    {invoice.amount}
                  </p>
                  <p className="hidden text-sm text-gray-500 sm:block">
                    {invoice.date}
                  </p>
                </div>
              </div>
            );
          })}
        </div>
        <div className="flex items-center pb-2 pt-6">
          <ArrowPathIcon className="h-5 w-5 text-gray-500" />
          <h3 className="ml-2 text-sm text-gray-500">Updated just now</h3>
        </div>
      </div>
    </div>
  );
}

