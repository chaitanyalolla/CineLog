"use client";

import { usePathname } from "next/navigation";
import Link from "next/link";

interface BreadcrumbItem {
  label: string;
  href?: string;
}

export default function Breadcrumbs({
  customItems,
}: {
  customItems?: BreadcrumbItem[];
}) {
  const pathname = usePathname();

  if (pathname === "/") {
    return null;
  }

  const breadcrumbs: BreadcrumbItem[] = [{ label: "Home", href: "/" }];

  if (customItems) {
    breadcrumbs.push(...customItems);
  }

  return (
    <nav className="flex items-center space-x-2 text-sm mb-4">
      {breadcrumbs.map((crumb, index) => (
        <div key={index} className="flex items-center">
          {index > 0 && <span className="mx-2 text-gray-400">&gt;</span>}
          {crumb.href && index < breadcrumbs.length - 1 ? (
            <Link href={crumb.href} className="text-blue-500 hover:underline">
              {crumb.label}
            </Link>
          ) : (
            <span className="text-gray-600">{crumb.label}</span>
          )}
        </div>
      ))}
    </nav>
  );
}
